#!/bin/bash
#
# Script to check and update requirements for Python apps
#
set -euo pipefail
IFS=$'\n\t'

APP=(
  "ansible" \
  "sslyze" \
)

# setup git
git config user.name "updatebot"
git config user.email "jauderho+update@users.noreply.github.com"
git config pull.rebase false

# setup pipenv and python
PATH="$HOME/.local/bin:$PATH"
pipenv install --python 3.9
pipenv shell

for i in "${APP[@]}"
do
	cd "${i}"

	echo "Updating ${i} ..."
	echo

	../.local/bin/pipenv lock && \
	../.local/bin/pipenv lock -r > requirements.txt

	git add Pipfile Pipfile.lock requirements.txt && \
	git commit -m "Update requirements for ${i} ..." && \
	git pull && \
	git push

	echo
	echo

	cd ..
done

