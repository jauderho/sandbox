# Runbook: Surgically flush buildx (`type=gha`) cache from a repo

A reusable procedure for when GitHub Actions Cache is pegged at the **10 GiB
per-repo cap** by buildx `type=gha` build cache (`buildkit-blob-*` /
`index-buildkit-*` entries), starving your *useful* caches (Trivy DB, binfmt,
etc.) which then get LRU-evicted.

Two parts:
1. **Flush** the existing buildkit cache entries (reclaims space now).
2. **Stop the bleed** by removing `cache-from`/`cache-to: type=gha` from the
   workflows (otherwise the cache refills within a day).

> Requires: `gh` (authenticated, repo scope), `jq`, `rg` (ripgrep), `perl`.
> Run everything from the repo root unless noted. Set the repo once:
> ```bash
> R=OWNER/REPO          # e.g. jauderho/dockerfiles
> ```

---

## 0. Diagnose — where is the cache going?

```bash
gh cache list -R "$R" -L 2000 --json id,key,sizeInBytes > /tmp/caches.json

# Total + breakdown by category
jq -r '
  def cat: if (startswith("buildkit-blob-") or startswith("index-buildkit-")) then "buildkit (build cache)"
           elif startswith("cache-trivy-")       then "cache-trivy"
           elif startswith("trivy-binary-")      then "trivy-binary"
           elif startswith("docker.io--tonistiigi--binfmt") then "binfmt"
           elif startswith("harden-runner")      then "harden-runner"
           else "other" end;
  "Total: \((([.[].sizeInBytes]|add)/1073741824*100|round)/100) GiB across \(length) entries",
  (group_by(.key|cat)
   | map({c:(.[0].key|cat), n:length, gib:(([.[].sizeInBytes]|add)/1073741824*1000|round/1000)})
   | sort_by(-.gib)[] | "  \(.gib) GiB\t\(.n)\t\(.c)")
' /tmp/caches.json
```

If `buildkit (build cache)` dominates (commonly >90%), proceed.

---

## 1. Flush the buildkit cache entries

Delete **only** `buildkit-blob-*` and `index-buildkit-*`; keep everything else.

```bash
# Build the delete list (IDs)
jq -r '.[] | select(.key|(startswith("buildkit-blob-") or startswith("index-buildkit-"))) | .id' \
  /tmp/caches.json > /tmp/delete_ids.txt
wc -l < /tmp/delete_ids.txt

# SAFETY: confirm nothing non-buildkit slipped in (should print the "clean" line)
jq -r '.[] | select(.key|(startswith("buildkit-blob-") or startswith("index-buildkit-"))) | .key' /tmp/caches.json \
  | rg -v '^(buildkit-blob-|index-buildkit-)' && echo "!! NON-BUILDKIT SELECTED — STOP" || echo "clean"
```

Delete in parallel. `gh cache delete` takes a cache **id** or **key**; by id it
is non-interactive.

```bash
# -P 3 to -P 4 avoids GitHub secondary rate-limiting. Higher = more transient fails.
xargs -P 3 -I {} sh -c 'gh cache delete -R "'"$R"'" "{}" >/dev/null 2>&1 || echo "FAIL {}"' \
  < /tmp/delete_ids.txt | tee /tmp/fails.txt
echo "fails: $(rg -c FAIL /tmp/fails.txt || echo 0)"
```

### Handle rate-limit failures
Failures are almost always transient (HTTP 403 secondary rate limit), not real
errors — re-running succeeds. Loop until the buildkit entries are gone:

```bash
for round in 1 2 3; do
  gh cache list -R "$R" -L 2000 --json id,key \
    | jq -r '.[] | select(.key|(startswith("buildkit-blob-") or startswith("index-buildkit-"))) | .id' \
    > /tmp/remain.txt
  n=$(wc -l < /tmp/remain.txt); echo "round $round: $n remaining"
  [ "$n" -eq 0 ] && break
  xargs -P 3 -I {} sh -c 'gh cache delete -R "'"$R"'" "{}" >/dev/null 2>&1 || true' < /tmp/remain.txt
done
```

### Verify
```bash
gh cache list -R "$R" -L 2000 --json key,sizeInBytes \
  | jq -r '"Total: \((([.[].sizeInBytes]|add // 0)/1048576*10|round)/10) MiB across \(length) entries",
           ([.[].key | select(startswith("buildkit"))] | "buildkit left: \(length)")'
```
Expect `buildkit left: 0`.

> **Alternative:** `gh cache delete --all` wipes *every* cache including the ones
> you want to keep. Only use it if you truly want a full reset.

---

## 2. Stop the bleed — remove `type=gha` from workflows

The cache refills on the next build unless you remove the directives. This
removes only **active** `cache-from`/`cache-to: type=gha` lines and leaves
commented ones alone.

> **Gotcha:** `.github` is a hidden directory. `rg` skips hidden paths by
> default — always pass `--hidden` (or give explicit file paths), or you will
> silently match nothing.

```bash
# Inventory: how many active lines, and confirm none are non-gha (e.g. registry cache to keep)
rg -n --hidden '^\s*cache-(from|to):\s*type=gha' .github/workflows/ | wc -l
rg -n --hidden '^\s*cache-(from|to):' .github/workflows/ | rg -v 'type=gha' || echo "(all gha)"

# Files to edit
files=$(rg -l --hidden '^\s*cache-(from|to):\s*type=gha' .github/workflows/)

# Delete active lines only (lines starting with '#' won't match)
perl -ni -e 'print unless /^\s*cache-(from|to):\s*type=gha/' $files

# Verify: 0 active lines remain; commented ones preserved
rg -c --hidden '^\s*cache-(from|to):\s*type=gha' .github/workflows/ | wc -l   # -> 0
git diff --stat | tail -3                                                     # only deletions
```

Validate YAML still parses before committing:

```bash
uv run --quiet --with pyyaml python - <<'PY'
import glob, sys, yaml
bad=[(f,str(e).splitlines()[0]) for f in glob.glob(".github/workflows/*.yml")
     for e in [None]
     if (lambda:
         (yaml.safe_load(open(f)) , False)[1] if False else
         _try(f))()]
def _try(f):
    try: yaml.safe_load(open(f)); return False
    except Exception as e: bad.append((f,str(e).splitlines()[0])); return False
print("INVALID:" , bad) if bad else print("all parse OK")
PY
```
(Or simpler: `for f in .github/workflows/*.yml; do python3 -c "import yaml,sys;yaml.safe_load(open(sys.argv[1]))" "$f" || echo "BAD $f"; done`)

Commit (signed) and push:

```bash
git add .github/workflows/
git commit -S -s -m "Remove type=gha build cache from image workflows"
git push
```

---

## Why this is the right call (decision criteria)

`type=gha` build cache only pays off if builds actually **hit** it. It does
**not** when, as in this repo's pattern:

- The build stage is one monolithic `RUN` gated on a version arg
  (`RUN test -n "${BUILD_VERSION}" && ... && <compile>`). A version bump — the
  only reason the build runs — changes the layer's cache key and rebuilds
  everything. Measured hit rate: 0–6 layers out of ~140.
- There's no version-independent dependency layer (no `COPY go.mod`/`Cargo.toml`
  before the version arg) and no `--mount=type=cache`, so nothing survives a bump.
- Wall time is dominated by **QEMU multi-arch emulation** (arm/v7, s390x,
  ppc64le), which layer cache cannot accelerate.

Check your own repo before deleting:
```bash
# How many distinct build layers were reused on a recent run? (near 0 == cache useless)
rid=$(gh run list -R "$R" --workflow WORKFLOW.yml --status success -L1 --json databaseId -q '.[0].databaseId')
gh run view -R "$R" "$rid" --log | rg -c '#[0-9]+ CACHED'
```

If your builds *do* get real hits (single-arch, deps cached before the version
arg, or cache mounts with `mode=max`), prefer **registry-backed cache**
(`type=registry,ref=ghcr.io/OWNER/IMG:buildcache`) instead of `type=gha` — it
moves the data off the 10 GiB GH budget entirely.

---

## Notes
- The 10 GiB cache limit is **per repo on every plan** (free included); deleting
  caches never costs Actions minutes.
- If you skip Part 2, leftover entries are auto-evicted after 7 days of no
  access anyway — but they keep refilling and re-evicting your good caches until
  the workflows are fixed.
- `gh cache delete` rate-limits under high parallelism; `-P 3` + the retry loop
  is the reliable combo for thousands of entries.
