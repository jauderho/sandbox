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
  "pip-audit" \
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
	git add "${i}/pyproject.toml" "${i}/uv.lock" 2>/dev/null || true

	if ! git diff --cached --quiet -- "${i}"; then
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
