#!/bin/bash
#
# Script to check and start new image builds if the source repos have new releases
#
# Usage: PAT=<user>:<token> scripts/updateDockerDeps.sh [--dryrun]
#
# Switches:
#   --dryrun    Show what would change without editing, committing or pushing
#
# Environment variables:
#   PAT         GitHub "<user>:<token>" (used to avoid API rate limits)
#   ARTEX_TAG   Sync artex to this tag instead of the latest release
#
# Most repos only have BUILD_VERSION bumped to the latest release. Custom
# variants (see the case in the main loop) update more than that:
#   BaaRai/ARTEX  update_artex: every pin in artex.yml, from upstream's own
#                 Dockerfile and the versions derived from it
#
set -euo pipefail
IFS=$'\n\t'

# $PAT variable needs to be passed into the script as an env variable
# PAT="user:token"

REPO=(
	"BaaRai/ARTEX" \
	"nabla-c0d3/sslyze" \
)

DRYRUN=false
for arg in "$@"; do
	case "$arg" in
		--dryrun) DRYRUN=true; echo "[dryrun] No files will be modified or committed."; echo ;;
		*) echo "Unknown argument: $arg" >&2; exit 1 ;;
	esac
done

: "${PAT:?PAT must be set as <user>:<token>}"

# ---------------------------------------------------------------------------
# Shared helpers
# ---------------------------------------------------------------------------
fetch() { curl -fsSL --proto '=https' --proto-redir '=https' "$@"; }
gh_api() { fetch -u "$PAT" -H "Accept: application/vnd.github+json" "https://api.github.com/$1"; }
raw() { fetch "https://raw.githubusercontent.com/$1/$2/$3"; }

sha256() {
	if command -v sha256sum >/dev/null; then sha256sum "$1" | cut -d' ' -f1
	else shasum -a 256 "$1" | cut -d' ' -f1; fi
}

# Accept only plausible version/digest strings: safe characters, at least one
# digit. Guarantees nothing that could break a sed substitution gets in.
is_valid_version() { [[ "$1" =~ ^[A-Za-z0-9._+~-]+$ && "$1" =~ [0-9] ]]; }

# Portable in-place edit (GNU and BSD sed disagree on -i).
sed_inplace() {
	local expr="$1" file="$2" tmp
	tmp=$(mktemp)
	sed -E "$expr" "$file" > "$tmp" && cat "$tmp" > "$file"
	rm -f "$tmp"
}

# ---------------------------------------------------------------------------
# update_artex: bring .github/workflows/artex.yml in step with an ARTEX release:
# the release tag plus every version upstream's own Dockerfile pins, and the
# versions derived from them (bbot's legba pin, api-recon's puppeteer-core).
# Release-binary digests are taken from upstream's Dockerfile and re-verified by
# downloading the assets (computed where upstream pins none, and for legba).
# Validates everything before editing; commits but leaves pushing to the end
# of the script. Not managed: PYTHON_VERSION (ours) and artex/Dockerfile's base
# images. After an update, run the differential suite in artex/tests.
#
# Runs in a subshell (see the main loop), so `exit` only ends this variant.
# ---------------------------------------------------------------------------
update_artex() {
	local WORKFLOW=".github/workflows/artex.yml" UPSTREAM="BaaRai/ARTEX" BBOT_REPO="blacklanternsecurity/bbot"
	local TAG k m known t v a key pinned url got new old mcp_core bbot_nuclei
	TMP=$(mktemp -d)   # global on purpose: the EXIT trap outlives the function (subshell-scoped anyway)
	trap 'rm -rf "$TMP"' EXIT

	# Resolved values live in NEW_<KEY> variables (bash 3.2 has no associative arrays).
	setnew() { printf -v "NEW_$1" '%s' "$2"; }
	getnew() { local n="NEW_$1"; printf '%s' "${!n:-}"; }
	# Current value of an env key in the workflow ("" if absent).
	current() { grep -m1 -E "^  $1: \"" "$WORKFLOW" | cut -d'"' -f2 || true; }

	TAG="${ARTEX_TAG:-}"
	if [[ -z "$TAG" ]]; then
		TAG=$(gh_api "repos/${UPSTREAM}/releases/latest" | jq -r '.tag_name // empty')
	fi
	is_valid_version "$TAG" || { echo "ERROR: could not resolve an ARTEX release tag (got '$TAG')" >&2; exit 1; }

	echo "    Dockerfile version is $(current BUILD_VERSION)"
	echo "    Repo version is	  ${TAG}"
	echo

	raw "$UPSTREAM" "$TAG" Dockerfile > "$TMP/Dockerfile" \
		|| { echo "ERROR: could not fetch upstream Dockerfile at ${TAG}" >&2; exit 1; }

	# Every "ARG NAME=value" upstream pins, as NAME<TAB>value.
	grep -E '^ARG [A-Z0-9_]+=' "$TMP/Dockerfile" | sed -E 's/^ARG ([A-Z0-9_]+)=(.*)$/\1\t\2/' > "$TMP/pins" || true
	upin() { awk -F'\t' -v k="$1" '$1 == k { print $2; exit }' "$TMP/pins"; }

	# Keys copied verbatim from upstream's Dockerfile.
	local FROM_UPSTREAM=(
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
	local IGNORED_UPSTREAM=(ARTEX_VERSION NODE_VERSION NODE_SHA256_AMD64 NODE_SHA256_ARM64)

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

	# Release-asset digests: verify upstream's, compute missing ones and legba's.
	# Only assets whose version or digest changes are downloaded.
	asset_url() { # <tool> <version> <arch>
		local t="$1" v="$2" a="$3" gh="https://github.com" pd dx lg
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
			echo "    Downloading ${url##*/} ..."
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

	# Validate everything before touching the file, so a failure never leaves a
	# half-updated workflow behind.
	local KEYS=(BUILD_VERSION "${FROM_UPSTREAM[@]}" LEGBA_VERSION LEGBA_SHA256_AMD64 LEGBA_SHA256_ARM64 PUPPETEER_CORE_VERSION)
	local changes=()
	for k in "${KEYS[@]}"; do
		new="$(getnew "$k")"
		old="$(current "$k")"
		is_valid_version "$new" || { echo "ERROR: could not resolve ${k} (got '${new}'); artex left unchanged." >&2; exit 1; }
		[[ -n "$old" ]] || { echo "ERROR: ${k} is missing from ${WORKFLOW}; artex left unchanged." >&2; exit 1; }
		if [[ "$old" != "$new" ]]; then
			printf '    %-24s %s -> %s\n' "$k" "$old" "$new"
			changes+=("$k")
		fi
	done

	if [[ ${#changes[@]} -eq 0 ]]; then
		echo "No update needed ..."
	elif $DRYRUN; then
		echo "[dryrun] Would update ${#changes[@]} value(s) in ${WORKFLOW}."
	else
		echo "Updating to ${TAG} ..."
		for k in "${changes[@]}"; do
			sed_inplace "s/^(  ${k}: )\"[^\"]*\"/\\1\"$(getnew "$k")\"/" "$WORKFLOW"
		done
		git add "$WORKFLOW"
		git commit -S -s -m "Updated artex to ${TAG}" \
			-m "Synced with upstream's pins: $(printf '%s ' "${changes[@]}")"
	fi

	# Reminders
	mcp_core=$(fetch "https://registry.npmjs.org/@playwright/mcp/$(getnew PLAYWRIGHT_MCP_VERSION)" \
		| jq -r '.dependencies["playwright-core"] // empty') || true
	if [[ -n "$mcp_core" && "$mcp_core" == "$(getnew PLAYWRIGHT_VERSION)" ]]; then
		echo "NOTE: @playwright/mcp $(getnew PLAYWRIGHT_MCP_VERSION) now pins playwright-core ${mcp_core} itself;" \
			"the override in artex/Dockerfile can be dropped."
	fi
	if [[ ${#changes[@]} -gt 0 ]]; then
		echo "NOTE: run the differential suite (artex/tests) against upstream's ${TAG} image."
	fi
}

# setup git
if ! $DRYRUN; then
	git config --local user.name "Gromit Bot"
	git config --local user.email "gromit-bot@users.noreply.github.com"
	git config --local pull.rebase false
fi

#
# Pull in the latest version from GitHub and if there is a newer version, update GitHub Actions to trigger a new build
# Right noew it's just a string compare
for i in "${REPO[@]}"
do

	prog=$(echo "$i" | sed -e "s/.*\///" | tr '[:upper:]' '[:lower:]')

	echo "Checking repo ... $prog"
	echo

	$DRYRUN || git pull

	# Custom variants update more than BUILD_VERSION
	case "$i" in
		"BaaRai/ARTEX")
			# Subshell: a failure ends only this variant, with set -e in force.
			set +e
			( set -e; update_artex )
			rc=$?
			set -e
			[[ $rc -eq 0 ]] || echo "WARNING: artex update failed (exit $rc); skipped." >&2
			echo
			echo
			echo
			continue
			;;
	esac

	dver=$(grep "BUILD_VERSION:" ".github/workflows/${prog}.yml" | cut -d \" -f 2)

	if [ "$i" != "ansible/ansible" ]; then
		#rver=$(curl -sL -u "$PAT" "https://api.github.com/repos/${i}/releases/latest" | grep tag_name | head -1 | cut -d \" -f 4)
		rver=$(curl -sL --proto '=https' --proto-redir '=https' -u "$PAT" "https://api.github.com/repos/${i}/releases/latest" | jq -r '.tag_name')
		#rver=$(curl -sL "https://api.github.com/repos/${i}/releases/latest" | grep tag_name | head -1 | cut -d \" -f 4)
		#rver="2021.02.04.1"

	else

		# special case for ansible
		# ansible is a pain and does not put the release tag in the same repo (ansible/ansible) but ansible-community/ansible-build-data instead
		# hence this insanity
		# for some reason, https://api.github.com/repos/ansible-community/ansible-build-data/releases/latest is returning 404
		rver=$(curl -sL --proto '=https' --proto-redir '=https' https://pypi.org/pypi/ansible/json | jq -r '.info.version')
	fi

	echo "    Dockerfile version is $dver"
	echo "    Repo version is	  $rver"
	echo

	if [ "$dver" != "$rver" ]; then
		if $DRYRUN; then
			echo "[dryrun] Would update to ${rver} ..."
		else
			echo "Updating to ${rver} ..."

			sed -i -e "s/$dver/$rver/" ".github/workflows/${prog}.yml" && \
			git add ".github/workflows/${prog}.yml" && \
			git commit -S -s -m "Updated ${prog} to ${rver}"
		fi

	else
		echo "No update needed ..."
	fi

	echo
	echo
	echo
done

# Make it so
$DRYRUN || git push
