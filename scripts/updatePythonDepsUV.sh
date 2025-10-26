#!/bin/bash
#
# Script to check and update requirements for Python apps
#
set -euo pipefail
IFS=$'\n\t'

APP=(
  "ai-hedge-fund" \
  "aider" \
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
  "internetarchive" \
  "jc" \
  "llama-cpp-agent" \
  "llama-fs" \
  "llm" \
  "memray" \
  "mlx-hub" \
  "notdiamond" \
  "open-interpreter" \
  "openbbterminal" \
  "paperless-ngx" \
  "pip-audit" \
  "pipenv-poetry-migrate" \
  "posting" \
  "prowler" \
  "pshtt" \
  "pyaranet4" \
  "pwnagotchi" \
  "revchatgpt" \
  "scrapeghost" \
  "shodan" \
  "wtfis" \
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

###DEBIAN_FRONTEND=noninteractive sudo apt-get install -y --no-install-recommends pipenv python3.12
###python3.12 -m pip install --no-cache-dir --upgrade pip --break-system-packages
###python3.12 -m pip install --no-cache-dir --upgrade --user pipenv certifi wheel setuptools packaging --break-system-packages

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

	#uv lock --prerelease=allow && uv pip compile pyproject.toml --no-annotate --prerelease=allow > requirements.txt 
	if [[ "$i" == "openbbterminal" ]]; then
		uv lock --prerelease=allow && uv pip compile pyproject.toml --no-annotate --prerelease=allow > requirements.txt
	else
		uv lock && uv pip compile pyproject.toml --no-annotate > requirements.txt
	fi

	git pull && \
	git add pyproject.toml uv.lock requirements.txt && \
	git commit -S -s -m "Update requirements for ${i} ..." && \
	git pull && \
	git push

	echo
	echo

	cd ..
done

