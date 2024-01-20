#!/bin/bash
#
# Script to check and update requirements for Python apps
#
set -euo pipefail
IFS=$'\n\t'

APP=(
  "aranet4" \
  "autoflake" \
  "awscli" \
  "cantools" \
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

#APP=(
#  "pshtt" \
#  "pwnagotchi" \
#)

# setup git
git config --global user.name "Jauder Ho"
git config --global user.email "jauderho@users.noreply.github.com"
git config --global pull.rebase false

# setup pipenv and python
#PATH="$HOME/.local/bin:$PATH"
#pipenv install --python 3.9
#pipenv shell
DEBIAN_FRONTEND=noninteractive sudo apt-get install -y --no-install-recommends pipenv python3.11
python3.11 -m pip install --no-cache-dir --upgrade pip
python3.11 -m pip install --no-cache-dir --upgrade --user pipenv certifi wheel setuptools packaging
#python3.11 -m pip install --no-cache-dir --upgrade --user pipenv
#python3.11 -m pip install --no-cache-dir --upgrade --user certifi
#DEBIAN_FRONTEND=noninteractive sudo apt-get install -y --no-install-recommends pipenv 
#python -m pip install --no-cache-dir --upgrade pip
#python -m pip install --no-cache-dir --upgrade --user pipenv
#python -m pip install --no-cache-dir --upgrade --user certifi

for i in "${APP[@]}"
do
	cd "${i}"

	echo
	echo "Updating ${i} ..."
	echo

	pipenv --python 3.11 lock -v && pipenv --python 3.11 requirements > requirements.txt
	#pipenv lock && pipenv requirements > requirements.txt

	git add Pipfile Pipfile.lock requirements.txt && \
	git commit -s -m "Update requirements for ${i} ..." && \
	git pull && \
	git push

	echo
	echo

	cd ..
done

