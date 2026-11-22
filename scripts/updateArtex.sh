#!/bin/bash
#
# Check BaaRai/ARTEX for a new release and bring .github/workflows/artex.yml in
# step with it: the release tag plus every version upstream's own Dockerfile
# pins, and the versions derived from them (bbot's legba pin, api-recon's
# puppeteer-core). Release-binary digests are taken from upstream's Dockerfile
# and re-verified by downloading the assets; legba's are computed.
#
# Usage: [PAT=<actor>/<token>] scripts/updateArtex.sh [--dryrun] [--tag vX.Y.Z]
#
# Switches:
#   --dryrun    Show what would change without editing, committing or pushing
#   --tag TAG   Sync to TAG instead of the latest release (e.g. to re-sync)
#
# Environment variables:
#   PAT         GitHub "<actor>/<token>" (optional; only avoids API rate limits)
#
# Not managed here: PYTHON_VERSION (ours, not upstream's) and the base images
# in artex/Dockerfile. After an update, run the differential suite in
# artex/tests against an image built from upstream's Dockerfile.
#
# Dependencies: bash (3.2+), curl, jq, git, sha256sum or shasum
#
set -euo pipefail
IFS=$'\n\t'

WORKFLOW=".github/workflows/artex.yml"
UPSTREAM="BaaRai/ARTEX"
BBOT_REPO="blacklanternsecurity/bbot"
BOT_NAME="Gromit Bot"
BOT_EMAIL="gromit-bot@users.noreply.github.com"

# ---------------------------------------------------------------------------
# Argument parsing
# ---------------------------------------------------------------------------
DRYRUN=false
TAG=""
while [[ $# -gt 0 ]]; do
	case "$1" in
		--dryrun) DRYRUN=true; echo "[dryrun] No files will be modified or committed."; echo ;;
		--tag) TAG="${2:?--tag needs a value}"; shift ;;
		*) echo "Unknown argument: $1" >&2; exit 1 ;;
	esac
	shift
done

cd "$(git rev-parse --show-toplevel)"
[[ -f "$WORKFLOW" ]] || { echo "ERROR: $WORKFLOW not found" >&2; exit 1; }

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

AUTH=()
if [[ -n "${PAT:-}" ]]; then
	AUTH=(-H "Authorization: Bearer ${PAT#*/}")
fi

# Resolved values live in NEW_<KEY> variables (bash 3.2 has no associative arrays).
setnew() { printf -v "NEW_$1" '%s' "$2"; }
getnew() { local n="NEW_$1"; printf '%s' "${!n:-}"; }

fetch() { curl -fsSL --proto '=https' --proto-redir '=https' "$@"; }
gh_api() { fetch ${AUTH[@]+"${AUTH[@]}"} -H "Accept: application/vnd.github+json" "https://api.github.com/$1"; }
raw() { fetch "https://raw.githubusercontent.com/$1/$2/$3"; }

sha256() {
	if command -v sha256sum >/dev/null; then sha256sum "$1" | cut -d' ' -f1
	else shasum -a 256 "$1" | cut -d' ' -f1; fi
}

# Accept only plausible version/digest strings: safe characters, at least one
# digit. Guarantees nothing that could break the sed substitution gets in.
is_valid_version() { [[ "$1" =~ ^[A-Za-z0-9._+~-]+$ && "$1" =~ [0-9] ]]; }

# Portable in-place edit (GNU and BSD sed disagree on -i).
sed_inplace() {
	local expr="$1" file="$2" tmp
	tmp=$(mktemp)
	sed -E "$expr" "$file" > "$tmp" && cat "$tmp" > "$file"
	rm -f "$tmp"
}

# Current value of an env key in the workflow ("" if absent).
current() { grep -m1 -E "^  $1: \"" "$WORKFLOW" | cut -d'"' -f2 || true; }

# ---------------------------------------------------------------------------
# Resolve the target release and upstream's pins
# ---------------------------------------------------------------------------
if [[ -z "$TAG" ]]; then
	TAG=$(gh_api "repos/${UPSTREAM}/releases/latest" | jq -r '.tag_name // empty')
fi
is_valid_version "$TAG" || { echo "ERROR: could not resolve an ARTEX release tag (got '$TAG')" >&2; exit 1; }

echo "ARTEX release        : ${TAG} (workflow has $(current BUILD_VERSION))"
echo

raw "$UPSTREAM" "$TAG" Dockerfile > "$TMP/Dockerfile" \
	|| { echo "ERROR: could not fetch upstream Dockerfile at ${TAG}" >&2; exit 1; }

# Every "ARG NAME=value" upstream pins, as NAME<TAB>value.
grep -E '^ARG [A-Z0-9_]+=' "$TMP/Dockerfile" | sed -E 's/^ARG ([A-Z0-9_]+)=(.*)$/\1\t\2/' > "$TMP/pins"
upin() { awk -F'\t' -v k="$1" '$1 == k { print $2; exit }' "$TMP/pins"; }

# Keys copied verbatim from upstream's Dockerfile.
FROM_UPSTREAM=(
	BBOT_VERSION PLAYWRIGHT_MCP_VERSION PLAYWRIGHT_CLI_VERSION PLAYWRIGHT_VERSION
	SQLMAP_VERSION SQLMAP_COMMIT
	NUCLEI_VERSION NUCLEI_SHA256_AMD64 NUCLEI_SHA256_ARM64
	HTTPX_VERSION HTTPX_SHA256_AMD64 HTTPX_SHA256_ARM64
	SUBFINDER_VERSION SUBFINDER_SHA256_AMD64 SUBFINDER_SHA256_ARM64
	KATANA_VERSION KATANA_SHA256_AMD64 KATANA_SHA256_ARM64
	FFUF_VERSION FFUF_SHA256_AMD64 FFUF_SHA256_ARM64
	DALFOX_VERSION DALFOX_SHA256_AMD64 DALFOX_SHA256_ARM64
)
# Upstream pins we deliberately do not carry (we use apt's nodejs; the
# version is passed as BUILD_VERSION).
IGNORED_UPSTREAM=(ARTEX_VERSION NODE_VERSION NODE_SHA256_AMD64 NODE_SHA256_ARM64)

setnew BUILD_VERSION "$TAG"
for k in "${FROM_UPSTREAM[@]}"; do
	setnew "$k" "$(upin "$k")"
done

# New upstream pins this script does not know about need a human decision.
while IFS=$'\t' read -r k _; do
	known=false
	for m in "${FROM_UPSTREAM[@]}" "${IGNORED_UPSTREAM[@]}"; do [[ "$k" == "$m" ]] && known=true; done
	$known || echo "WARNING: upstream pins ${k}, which artex.yml does not carry; review upstream's Dockerfile." >&2
done < "$TMP/pins"

# api-recon's runtime harvester: the puppeteer-core its lockfile resolves.
setnew PUPPETEER_CORE_VERSION "$(raw "$UPSTREAM" "$TAG" skills/api-recon/scripts/package-lock.json \
	| jq -r '.packages["node_modules/puppeteer-core"].version // empty')"

# bbot's module pins: legba is shipped by us at bbot's version; nuclei must
# equal upstream's, or the image build's equality check fails.
bbot_pin() {
	raw "$BBOT_REPO" "v$(getnew BBOT_VERSION)" "bbot/modules/$1.py" \
		| sed -nE 's/.*version: str = Field\("([^"]+)".*/\1/p' | head -1
}
setnew LEGBA_VERSION "$(bbot_pin legba)"
bbot_nuclei=$(bbot_pin nuclei)
if [[ -n "$bbot_nuclei" && "v${bbot_nuclei}" != "$(getnew NUCLEI_VERSION)" ]]; then
	echo "WARNING: bbot $(getnew BBOT_VERSION) pins nuclei ${bbot_nuclei} but upstream ships $(getnew NUCLEI_VERSION);" \
		"the image build will refuse this combination." >&2
fi

# ---------------------------------------------------------------------------
# Release-asset digests: verify upstream's, compute legba's. Only assets
# whose version changes are downloaded.
# ---------------------------------------------------------------------------
gh="https://github.com"
asset_url() { # <tool> <version> <arch>
	local t="$1" v="$2" a="$3" pd dx lg
	case "$a" in AMD64) pd=amd64 dx=x86_64 lg=x86_64 ;; ARM64) pd=arm64 dx=aarch64 lg=arm64 ;; esac
	case "$t" in
		NUCLEI)    echo "$gh/projectdiscovery/nuclei/releases/download/$v/nuclei_${v#v}_linux_${pd}.zip" ;;
		HTTPX)     echo "$gh/projectdiscovery/httpx/releases/download/$v/httpx_${v#v}_linux_${pd}.zip" ;;
		SUBFINDER) echo "$gh/projectdiscovery/subfinder/releases/download/$v/subfinder_${v#v}_linux_${pd}.zip" ;;
		KATANA)    echo "$gh/projectdiscovery/katana/releases/download/$v/katana_${v#v}_linux_${pd}.zip" ;;
		FFUF)      echo "$gh/ffuf/ffuf/releases/download/$v/ffuf_${v#v}_linux_${pd}.tar.gz" ;;
		DALFOX)    echo "$gh/hahwul/dalfox/releases/download/$v/dalfox-${v}-linux-${dx}-musl.tar.gz" ;;
		LEGBA)     echo "$gh/evilsocket/legba/releases/download/$v/legba-${v}-linux-${lg}.tar.gz" ;;
	esac
}

for t in NUCLEI HTTPX SUBFINDER KATANA FFUF DALFOX LEGBA; do
	v="$(getnew "${t}_VERSION")"
	for a in AMD64 ARM64; do
		key="${t}_SHA256_${a}"
		pinned="$(getnew "$key")"   # upstream's digest; always empty for legba
		if [[ "$v" == "$(current "${t}_VERSION")" && -z "$pinned" ]]; then
			# Same version and nothing pinned upstream: keep the digest we have.
			setnew "$key" "$(current "$key")"
			continue
		fi
		# Same version and same digest: nothing new to verify.
		[[ "$v" == "$(current "${t}_VERSION")" && "$pinned" == "$(current "$key")" ]] && continue
		url=$(asset_url "$t" "$v" "$a")
		echo "Downloading ${url##*/} ..."
		fetch -o "$TMP/asset" "$url" || { echo "ERROR: could not download $url" >&2; exit 1; }
		got=$(sha256 "$TMP/asset")
		if [[ -z "$pinned" ]]; then
			setnew "$key" "$got"
		elif [[ "$got" != "$pinned" ]]; then
			echo "ERROR: ${url##*/} has SHA-256 $got, upstream pins $pinned" >&2
			exit 1
		fi
	done
done
echo

# ---------------------------------------------------------------------------
# Apply
# ---------------------------------------------------------------------------
KEYS=(BUILD_VERSION "${FROM_UPSTREAM[@]}" LEGBA_VERSION LEGBA_SHA256_AMD64 LEGBA_SHA256_ARM64 PUPPETEER_CORE_VERSION)

# Validate everything before touching the file, so a failure never leaves a
# half-updated workflow behind.
changes=()
for k in "${KEYS[@]}"; do
	new="$(getnew "$k")"
	old="$(current "$k")"
	is_valid_version "$new" || { echo "ERROR: could not resolve ${k} (got '${new}'); aborting without changes." >&2; exit 1; }
	[[ -n "$old" ]] || { echo "ERROR: ${k} is missing from ${WORKFLOW}; aborting without changes." >&2; exit 1; }
	if [[ "$old" != "$new" ]]; then
		printf '  %-24s %s -> %s\n' "$k" "$old" "$new"
		changes+=("$k")
	fi
done

if ! $DRYRUN; then
	for k in ${changes[@]+"${changes[@]}"}; do
		sed_inplace "s/^(  ${k}: )\"[^\"]*\"/\\1\"$(getnew "$k")\"/" "$WORKFLOW"
	done
fi

if [[ ${#changes[@]} -eq 0 ]]; then
	echo "No update needed: artex.yml matches ARTEX ${TAG}."
else
	echo
	if $DRYRUN; then
		echo "[dryrun] Would update ${#changes[@]} value(s) in ${WORKFLOW}."
	else
		git add "$WORKFLOW"
		# Committed as Gromit Bot, like the other update scripts; set per command
		# so the repo's own identity is left alone. Still signed (-S) with the
		# configured signing key.
		git -c user.name="$BOT_NAME" -c user.email="$BOT_EMAIL" \
			commit -S -s -m "Updated artex to ${TAG}" \
			-m "Synced with upstream's pins: $(printf '%s ' "${changes[@]}")"
		git push
		echo "Committed and pushed."
	fi
fi

# ---------------------------------------------------------------------------
# Reminders
# ---------------------------------------------------------------------------
mcp_core=$(fetch "https://registry.npmjs.org/@playwright/mcp/$(getnew PLAYWRIGHT_MCP_VERSION)" \
	| jq -r '.dependencies["playwright-core"] // empty') || true
if [[ -n "$mcp_core" && "$mcp_core" == "$(getnew PLAYWRIGHT_VERSION)" ]]; then
	echo "NOTE: @playwright/mcp $(getnew PLAYWRIGHT_MCP_VERSION) now pins playwright-core ${mcp_core} itself;" \
		"the override in artex/Dockerfile can be dropped."
fi
if [[ ${#changes[@]} -gt 0 ]]; then
	echo "NOTE: run the differential suite (artex/tests) against upstream's ${TAG} image."
fi
