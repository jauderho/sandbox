#!/bin/bash
#
# Script to refresh the uv lock file for each Python app.
# uv.lock is the source of truth; no requirements.txt is generated.
#
set -euo pipefail
IFS=$'\n\t'

APP=(
  "ai-hedge-fund" \
  "aranet4" \
  "autoflake" \
  "awscli" \
  "badkeys" \
  "bgperf2" \
  "cantools" \
  "claude-engineer" \
  "codespell" \
  "cryptolyzer" \
  "datasette" \
  "deepdiff" \
  "diagrams" \
  "dnsdiag" \
  "dnsrecon" \
  "dnstwist" \
  "dnsvalidator" \
  "finanace_dl" \
  "gallery-dl" \
  "greynoise" \
  "hdbcli" \
  "huggingface-cli" \
  "ilab" \
  "internetarchive" \
  "jc" \
  "llama-fs" \
  "llm" \
  "memray" \
  "mlx" \
  "mlx-hub" \
  "notdiamond" \
  "openbbterminal" \
  "paperless-ngx" \
  "posting" \
  "prowler" \
  "pshtt" \
  "puncia" \
  "pwnagotchi" \
  "pyaranet4" \
  "pyinfra" \
  "python-matter-server" \
  "pyupgrade" \
  "revchatgpt" \
  "routellm" \
  "scrapeghost" \
  "sgpt" \
  "shodan" \
  "ssh-mitm" \
  "uv" \
  "wolverine" \
  "wtfis" \
)

#APP=(
#  "pshtt" \
#  "pwnagotchi" \
#)

# BUILD_VERSION in a workflow is only a label and an image tag - the version
# that actually ships comes from uv.lock. Nothing kept the two in step, so the
# labels drifted. Only apps that have a workflow need an entry here, and the
# package is named because it is not always the directory name.
WORKFLOW_PKG='autoflake:autoflake
awscli:awscli
badkeys:badkeys
cryptolyzer:cryptolyzer
greynoise:greynoise
huggingface-cli:huggingface-hub
jc:jc
llama-fs:llama-index
llm:llm
memray:memray
openbbterminal:openbb
pyinfra:pyinfra
sgpt:shell-gpt
shodan:shodan
ssh-mitm:ssh-mitm
uv:uv'

# Rewrite a workflow's BUILD_VERSION to the version its uv.lock resolved to.
# sed -i.bak keeps this portable between GNU and BSD sed.
sync_build_version() {
	local dir="$1" pkg wf ver
	pkg=$(printf '%s\n' "$WORKFLOW_PKG" | awk -F: -v d="${dir}" '$1==d{print $2; exit}')
	wf=".github/workflows/${dir}.yml"

	[[ -n "${pkg}" && -f "${wf}" && -f "${dir}/uv.lock" ]] || return 0

	ver=$(awk -v pkg="${pkg}" '
		/^name = / {n=$3}
		/^version = / {if (n=="\""pkg"\"") {print $3; exit}}
	' "${dir}/uv.lock" | tr -d '"')
	[[ -n "${ver}" ]] || return 0

	sed -i.bak -E "s|^  BUILD_VERSION: .*|  BUILD_VERSION: \"${ver}\"|" "${wf}"
	rm -f "${wf}.bak"
}

# setup git
git config --local user.name "Jauder Ho Bot"
git config --local user.email "jauderho-bot@users.noreply.github.com"
git config --local pull.rebase false

#PATH="$HOME/.local/bin:$PATH"

# Track lock failures so a single flaky app doesn't abort the whole run
FAILED=$(mktemp)
export FAILED

# Phase 1: resolve/lock every app in parallel (each dir is independent and
# the work is network/CPU bound on dependency resolution). No git here.
lock_app() {
	local i="$1"

	echo
	echo "Updating ${i} ..."
	echo

	if ! (
		cd "${i}" || exit 1
		if [[ "$i" == "openbbterminal" ]]; then
			uv lock --prerelease=allow -U
		else
			uv lock -U
		fi
	); then
		echo "FAILED to lock: ${i}" >&2
		echo "${i}" >> "$FAILED"
	fi
}
export -f lock_app

printf '%s\n' "${APP[@]}" | xargs -P "${LOCK_JOBS:-6}" -I {} bash -c 'lock_app "$@"' _ {}

# Phase 2: commit each app's changes serially, then push once at the end
git pull --no-edit

for i in "${APP[@]}"
do
	sync_build_version "${i}"

	PATHS=("${i}/pyproject.toml" "${i}/uv.lock")
	[[ -f ".github/workflows/${i}.yml" ]] && PATHS+=(".github/workflows/${i}.yml")

	git add "${PATHS[@]}" 2>/dev/null || true

	if ! git diff --cached --quiet -- "${PATHS[@]}"; then
		git commit -S -s -m "Update requirements for ${i} ..."
	fi
done

git push

# Surface any lock failures (after the successful updates have been pushed)
if [[ -s "$FAILED" ]]; then
	echo
	echo "The following apps failed to lock:"
	cat "$FAILED"
	rm -f "$FAILED"
	exit 1
fi
rm -f "$FAILED"
