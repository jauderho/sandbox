#!/bin/bash
#
# Script to check and update requirements for Python apps
#
set -euo pipefail
IFS=$'\n\t'

APP=(
  "aranet4" \
  "autoflake" \
  "chatgpt-linux-assistant" \
  "codespell" \
  "datasette" \
  "dnsdiag" \
  "dnsrecon" \
  "dnsvalidator" \
  "greynoise" \
  "hdbcli" \
  "jc" \
  "memray" \
  "openbbterminal" \
  "paperless-ngx" \
  "pip-audit" \
  "prowler" \
  "pshtt" \
  "pwnagotchi" \
  "pyaranet4" \
  "pyupgrade" \
  "ruff" \
  "scrapeghost" \
  "sgpt" \
  "ssh-mitm" \
  "wolverine" \
)

# setup git
git config user.name "Jauder Ho"
git config user.email "jauderho+update@users.noreply.github.com"
git config pull.rebase false

# setup pipenv and python
#PATH="$HOME/.local/bin:$PATH"
#pipenv install --python 3.9
#pipenv shell
DEBIAN_FRONTEND=noninteractive sudo apt-get install -y --no-install-recommends pipenv python3.11

for i in "${APP[@]}"
do
	cd "${i}"

	echo "Updating ${i} ..."
	echo

	pipenv --python 3.11 lock && pipenv --python 3.11 requirements > requirements.txt
	#pipenv lock && pipenv lock -r > requirements.txt

	git add Pipfile Pipfile.lock requirements.txt && \
	git commit -s -m "Update requirements for ${i} ..." && \
	git pull && \
	git push

	echo
	echo

	cd ..
done

