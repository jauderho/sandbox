#!/bin/bash
#
# Script to check and update requirements for Python apps
#
set -euo pipefail
IFS=$'\n\t'

APP=(
  "mlx" \
)

#APP=(
#  "pshtt" \
#  "pwnagotchi" \
#)

# setup git
git config --local user.name "Jauder Ho Bot"
git config --local user.email "jauderho-bot@users.noreply.github.com"
git config --local pull.rebase false

# setup pipenv and python
PATH="/Users/runner/Library/Python/3.13/bin:$HOME/.local/bin:$PATH"
#pipenv install --python 3.9
#pipenv shell
#DEBIAN_FRONTEND=noninteractive sudo apt-get install -y --no-install-recommends pipenv python3.13

#python3.13 -m pip install --no-cache-dir --upgrade pip --break-system-packages
###python3.13 -m pip install --no-cache-dir --upgrade --user pipenv certifi wheel setuptools packaging --break-system-packages

#python3.11 -m pip install --no-cache-dir --upgrade --user pipenv
#python3.11 -m pip install --no-cache-dir --upgrade --user certifi
#DEBIAN_FRONTEND=noninteractive sudo apt-get install -y --no-install-recommends pipenv 
#python -m pip install --no-cache-dir --upgrade pip
#python -m pip install --no-cache-dir --upgrade --user pipenv
#python -m pip install --no-cache-dir --upgrade --user certifi

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
		#pipenv --python 3.13 lock -v && pipenv --python 3.13 requirements --exclude-markers > requirements.txt
		#uv lock --prerelease=allow -U && uv pip compile pyproject.toml --python-platform aarch64-apple-darwin --no-annotate --prerelease=allow > requirements.txt
		uv lock --prerelease=allow -U && uv export --no-hashes --no-annotate --no-emit-workspace -o requirements.txt
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
	git add "${i}/pyproject.toml" "${i}/uv.lock" "${i}/requirements.txt" 2>/dev/null || true

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

