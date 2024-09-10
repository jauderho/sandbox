#!/bin/bash
#
# Script to check and update requirements for Python apps
#
set -euo pipefail
IFS=$'\n\t'

APP=(
  "aider" \
  "aranet4" \
  "autoflake" \
  "awscli" \
  "badkeys" \
  "bgperf2" \
  "cantools" \
  "chatgpt-linux-assistant" \
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
  "llama-cpp-agent" \
  "llama-fs" \
  "llm" \
  "memray" \
  "notdiamond" \
  "openbbterminal" \
  "open-interpreter" \
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
  "routellm" \
  "scrapeghost" \
  "sgpt" \
  "shodan" \
  "ssh-mitm" \
  "wolverine" \
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
#PATH="$HOME/.local/bin:$PATH"
#pipenv install --python 3.9
#pipenv shell
DEBIAN_FRONTEND=noninteractive sudo apt-get install -y --no-install-recommends pipenv python3.12
python3.12 -m pip install --no-cache-dir --upgrade pip --break-system-packages
python3.12 -m pip install --no-cache-dir --upgrade --user pipenv certifi wheel setuptools packaging --break-system-packages
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

	pipenv --python 3.12 lock -v && pipenv --python 3.12 requirements --exclude-markers > requirements.txt
	#pipenv lock && pipenv requirements > requirements.txt

	git add Pipfile Pipfile.lock requirements.txt && \
	git commit -S -s -m "Update requirements for ${i} ..." && \
	git pull && \
	git push

	echo
	echo

	cd ..
done

