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

for i in "${APP[@]}"
do
	cd "${i}"

	echo "Updating ${i} ..."
	echo

	pipenv lock
	pipenv lock -r > requirements.txt

	git add Pipfile Pipfile.lock requirements.txt
	git commit -m "Update requirements for ${i} ..."

	echo
	echo

	cd ..
done

# Make it so
git push
