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

for i in "${APP[@]}"
do
	cd "${i}"

	echo
	echo "Updating ${i} ..."
	echo

	#pipenv --python 3.13 lock -v && pipenv --python 3.13 requirements --exclude-markers > requirements.txt
	#pipenv lock && pipenv requirements > requirements.txt
	uv lock --prerelease=allow && uv pip compile pyproject.toml --python-platform aarch64-apple-darwin --no-annotate --prerelease=allow > requirements.txt

	#git add Pipfile Pipfile.lock requirements.txt && \
	git add pyproject.toml uv.lock requirements.txt && \
	git commit -S -s -m "Update requirements for ${i} ..." && \
	git pull && \
	git push

	echo
	echo

	cd ..
done

