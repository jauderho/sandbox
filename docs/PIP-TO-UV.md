# Migrating container images from pip to uv

A field guide for moving a repository of Python container images off `pip` and
onto [uv](https://github.com/astral-sh/uv), with `uv.lock` as the single source
of truth.

This is written from an actual migration of 23 images (Alpine and Ubuntu based,
amd64 + arm64) and documents the failures that were hit, not just the happy
path. The gotchas section is the valuable part; read it before you start.

---

## Why bother

| | pip | uv |
|---|---|---|
| PEP 668 on modern distros | needs `--break-system-packages` | not applicable, installs into a venv |
| Distro `pip`/`packaging` conflicts | needs `--ignore-installed` | not applicable |
| Resolution speed | baseline | roughly 5-10x faster |
| Final image | ships pip, wheel, setuptools, often the toolchain | ships neither |
| Source of truth | a generated `requirements.txt` | `pyproject.toml` + `uv.lock` |

Typical size results from the real migration:

```
openbbterminal   1.53 GB -> 848 MB     (-45%)
llama-fs           990 MB -> 759 MB    (-23%)
awscli             322 MB -> 289 MB
sgpt               177 MB -> 151 MB
most small images  2-7% smaller
```

**Most of the size win comes from going multi-stage, not from uv itself.** The
openbbterminal image was shipping `gcc`, `gfortran` and `pip` because
`apt-get autoremove` will not remove an explicitly installed `build-essential`.
If you only swap the installer and stay single stage, expect a couple of
percent, not 45.

---

## The two target patterns

### Alpine

`uv` is in the Alpine community repo and is built for every arch Alpine
supports. Prefer it over the official image when you build more than
amd64/arm64.

```dockerfile
FROM alpine:3.24.1@sha256:... AS build

ENV UV_PROJECT_ENVIRONMENT=/opt/venv \
	UV_NO_CACHE=1 \
	UV_LINK_MODE=copy \
	UV_PYTHON_DOWNLOADS=never

COPY pyproject.toml uv.lock ./

RUN apk update && apk upgrade -a && \
	apk --no-cache add python3 uv <build deps> && \
	uv sync --frozen --no-install-project --no-dev --python /usr/bin/python3 && \
	find /opt/venv -name '__pycache__' -print0 | xargs -0 -n1 rm -rf


FROM alpine:3.24.1@sha256:...     # same digest as the build stage

RUN apk update && apk upgrade -a && \
	apk --no-cache add ca-certificates python3 <runtime deps> && \
	rm -rf /var/cache/apk/*

COPY --from=build /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:${PATH}"

RUN <smoke test> && \
	find /opt/venv -name '__pycache__' -print0 | xargs -0 -n1 rm -rf
```

### Debian / Ubuntu

No distro package for uv, so take it from the official image. **That image
publishes amd64 and arm64 only** - if you build armv7, ppc64le or s390x you
must fetch the release tarball per `TARGETARCH` instead.

```dockerfile
FROM ghcr.io/astral-sh/uv:0.12.7@sha256:... AS uv

FROM ubuntu:26.04@sha256:... AS build
ENV UV_PROJECT_ENVIRONMENT=/opt/venv \
	UV_NO_CACHE=1 \
	UV_LINK_MODE=copy \
	UV_PYTHON_DOWNLOADS=never

COPY --from=uv /uv /usr/local/bin/uv
COPY pyproject.toml uv.lock ./

RUN apt-get update && apt-get dist-upgrade -y && \
	apt-get install -y --no-install-recommends python3 <build deps> && \
	uv sync --frozen --no-install-project --no-dev --python /usr/bin/python3
```

### Single stage, when you cannot avoid it

If the image installs a local project and needs its console script on
`/usr/local/bin`, or sets `USER`, a venv may be more trouble than it is worth.
Install with `--system` and **bind mount uv rather than `COPY`ing it**:

```dockerfile
RUN --mount=from=uv,source=/uv,target=/usr/local/bin/uv \
    uv pip install --system --no-cache /app
```

`COPY --from=uv` puts a ~35 MB binary in its own layer; a later `rm` cannot
reclaim it. Bind mounting cost us nothing and saved 29 MB on one image.

---

## Phased plan

Each phase has an explicit **gate**. Do not start the next phase until the gate
passes. The gates exist because two of the bugs found in this migration would
have shipped silently otherwise.

### Phase 0 - inventory and baseline

1. List every Dockerfile that invokes pip:
   ```bash
   rg -l '^[^#]*(\bpip3? install|python3? -m pip)' --glob 'Dockerfile*'
   ```
2. Confirm each has `pyproject.toml` + `uv.lock`. Any directory without both is
   a special case - handle it explicitly or exclude it.
3. **Record a baseline for every image**: size, and the output of its entrypoint
   with a benign flag. You cannot detect a regression you never measured.
4. Identify images that build architectures outside amd64/arm64.

**Gate:** you can rebuild every image from `HEAD` and have a recorded baseline
for each. If an image does not build *before* the migration, say so now - do
not discover it later and attribute it to uv.

### Phase 1 - pilot one image

Pick the *simplest representative* image, not the easiest one. Convert it, then
prove equivalence:

- builds
- entrypoint output is identical to baseline
- installed package set is identical (see the parity check below)
- image size is not materially larger

**Gate:** package set identical apart from `pip` / `wheel` / `packaging`, and
byte-identical entrypoint output.

### Phase 2 - pilot a hard image

Deliberately choose the nastiest case: compiled dependencies, a different base
distro, a non-root `USER`, or an exotic arch. This is where you learn what your
converter script gets wrong.

**Gate:** same as Phase 1, plus the build toolchain is provably absent from the
final image.

### Phase 3 - bulk conversion

Script it, but **guard the script**. A transform that silently half-applies is
worse than one that fails loudly:

```python
problems = []
if "requirements.txt" in text: problems.append("still references requirements.txt")
if "uv pip install" in text:   problems.append("uv pip install remains")
if "uv sync --frozen" not in text: problems.append("no uv sync")
if problems: print(f"!! {path}: {problems}")   # do NOT write the file
else: path.write_text(text)
```

In the real migration this guard caught four files the regex mishandled -
including one where a comment line inside a `RUN` continuation truncated the
block match and produced a mangled Dockerfile.

**Gate:** every image builds, and behavioural diffs against Phase 0 baselines
are either empty or explained in writing.

### Phase 4 - adversarial review

Do not skip this. Review your own diff as a hostile reviewer, mechanically:

```bash
# diff every directive between old and new
for k in ENTRYPOINT CMD USER WORKDIR VOLUME EXPOSE HEALTHCHECK STOPSIGNAL ENV; do
  diff <(git show "$PRE:$f" | grep "^$k ") <(grep "^$k " "$f")
done
```

Then check the specific classes in "Gotchas" below.

**Gate:** every difference is either intentional and documented, or fixed.

### Phase 5 - drop requirements.txt

Only once Phases 1-4 are green. Switch `uv pip install -r requirements.txt` to
`uv sync --frozen`, delete the generated files, and remove `uv export` from any
refresh script.

**Gate:** images rebuild after the files are actually deleted (not just after
the Dockerfile edit - a stale build context can mask this), and sizes are
unchanged from Phase 3.

### Phase 6 - CI on every architecture

Local builds on one arch prove very little. Push and let CI build every
platform you ship.

**Gate:** green on all architectures, for both uv acquisition strategies if you
use both.

---

## Gotchas

These all cost real time. They are ordered by how likely they are to bite.

### 1. The venv loses everything the distro's pip provided

This is the big one. `python3-pip` / `py3-pip` drags in `setuptools`, `wheel`
and `packaging` system-wide. Anything importing `pkg_resources` at startup
worked by accident and now fails.

Symptom:
```
ModuleNotFoundError: No module named 'pkg_resources'
```

Check *before* blaming your migration - in this repo shodan was already broken
on the pip image for exactly this reason, because `setuptools` **removed
`pkg_resources` in 81.0.0**. If you need it, pin `setuptools<81` and declare it
as a real dependency.

Find lazy importers that a `--help` smoke test will not reach:
```bash
grep -rl "import pkg_resources" /opt/venv/lib/python*/site-packages --include="*.py"
```

### 2. Absolute paths in ENTRYPOINT

`ENTRYPOINT ["/usr/local/bin/aws"]` breaks the moment the console script moves
to `/opt/venv/bin/aws`. Grep for absolute entrypoints before you convert:

```bash
rg 'ENTRYPOINT \["/usr' --glob 'Dockerfile*'
```

### 3. The final stage must have the same Python minor version

`uv venv` symlinks the interpreter and hardcodes `lib/python3.X`. If the build
and final stages resolve different minors, the venv is silently broken. Use the
identical base digest in both stages. A smoke test catches this; nothing else
will.

### 4. Smoke tests regenerate bytecode

If you strip `__pycache__` and *then* run a smoke test, the test writes it all
back. Combine them in one layer:

```dockerfile
RUN mytool --version && \
	find /opt/venv -name '__pycache__' -print0 | xargs -0 -n1 rm -rf
```
Missing this made one image 7 MB *larger* than its pip equivalent.

### 5. `uv sync` wants to build your project

These wrapper projects only declare dependencies and have no package to build.
Without `--no-install-project`, `uv sync` tries to build them and fails. Use:

```
uv sync --frozen --no-install-project --no-dev
```

`--frozen` means "install exactly the lock, never re-resolve" - that is the
whole point. Set `UV_PROJECT_ENVIRONMENT` or uv creates `.venv` in the workdir.

### 6. Runtime packages that were never declared

`git` is the usual one: some images install it, use it, and never purge it, so
it silently persists at runtime. Check whether the original *purged* it in the
same `RUN` before assuming your multi-stage build lost something:

```bash
git show "$PRE:$f" | rg 'apt-get purge -y.*\bgit\b'
```

### 7. Local package-manager config poisoning locks

A user-level `~/.config/uv/uv.toml` applies to your local `uv lock` runs but
not to CI. An `exclude-newer = "7 days"` setting silently produced *downgrades*
and polluted 56 lock files. Neutralise it:

```bash
: > /tmp/empty-uv.toml
UV_CONFIG_FILE=/tmp/empty-uv.toml uv lock -U
```

### 8. Dependabot will fight a deliberate pin

A constraint that exists for a correctness reason (`setuptools<81`) will be
"helpfully" widened. It happened mid-migration here and re-broke a working
image. Scope an `ignore` to the one directory that needs it - a repo-wide
ignore also suppresses genuine security updates elsewhere.

Dependabot has **no way to filter by manifest type**, so it keeps parsing any
`requirements.txt` you leave behind. Only deletion removes it from scope.

### 9. Verify your verification

Two "verified identical" results in this migration were wrong:

- the probe ran `rg` *inside* containers that do not have it, so both sides
  returned empty and compared equal
- the probe globbed only `site-packages`, missing Debian's `dist-packages`, so
  a fully populated image looked like it had zero packages

If a check reports "no differences", confirm it can actually detect one.

---

## The parity check that matters

Comparing sizes is weak. Compare the installed distributions:

```bash
pkgs() { docker run --rm --entrypoint sh "$1" -c '
  for d in /opt/venv/lib/python*/site-packages \
           /usr/lib/python3/dist-packages \
           /usr/local/lib/python*/dist-packages; do
    ls "$d" 2>/dev/null | grep "\.dist-info$" | sed "s/-[^-]*\.dist-info$//"
  done | sort -u'; }

diff <(pkgs old:image) <(pkgs new:image)
```

The expected diff is exactly `packaging`, `pip`, `wheel` - the distro build
tooling that was never a declared dependency. **Anything else is a real
regression.** Note the `dist-packages` paths; Debian and Ubuntu do not use
`site-packages` for system installs.

---

## Rollback

Every phase is a separate commit and each is independently revertible. Keep the
Dockerfile change and the `requirements.txt` deletion in the *same* commit -
splitting them leaves a commit that cannot build, which ruins bisection.

---

## Checklist

- [ ] Baseline size and entrypoint output recorded for every image
- [ ] Images already broken before migration identified and called out
- [ ] Pilot passes package-set parity, not just "it builds"
- [ ] Absolute `ENTRYPOINT` paths repointed at the venv
- [ ] Build and final stages share one base digest
- [ ] Bytecode stripped in the same layer as the smoke test
- [ ] Smoke test exercises a real import, not only `--help`
- [ ] Toolchain provably absent from final images
- [ ] Local uv config neutralised when locking
- [ ] CI green on every architecture shipped
- [ ] Dependabot ignores scoped to the directory that needs them
