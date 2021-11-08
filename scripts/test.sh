#!/bin/bash
#
# Script to check and start new image builds if the source repos have new releases
#
set -euo pipefail
IFS=$'\n\t'

# $PAT variable needs to be passed into the script as an env variable
# PAT="user:token"

REPO=( 
	"nabla-c0d3/sslyze" \
)

# setup git
git config user.name "Jauder Ho"
git config user.email "jauderho@users.noreply.github.com"

# 
# Pull in the latest version from GitHub and if there is a newer version, update GitHub Actions to trigger a new build
# Right noew it's just a string compare
for i in "${REPO[@]}"
do

	prog=$(echo "$i" | sed -e "s/.*\///")
	dver=$(grep "BUILD_VERSION:" ".github/workflows/${prog}.yml" | cut -d \" -f 2)

	if [ "$i" != "ansible/ansible" ]; then
		#rver=$(curl -sL -u "$PAT" "https://api.github.com/repos/${i}/releases/latest" | grep tag_name | head -1 | cut -d \" -f 4)
		rver=$(curl -sL -u "$PAT" "https://api.github.com/repos/${i}/releases/latest" | jq -r '.tag_name')
		#rver=$(curl -sL "https://api.github.com/repos/${i}/releases/latest" | grep tag_name | head -1 | cut -d \" -f 4)
		#rver="2021.02.04.1"

	else

		# special case for ansible
		# ansible is a pain and does not put the release tag in the same repo (ansible/ansible) but ansible-community/ansible-build-data instead
		# hence this insanity
		# for some reason, https://api.github.com/repos/ansible-community/ansible-build-data/releases/latest is returning 404
		rver=$(curl -sL https://pypi.org/pypi/ansible/json | jq -r '.info.version')
	fi

	echo "Checking repo ... $prog"
	echo 
	echo "    Dockerfile version is $dver"
	echo "    Repo version is	  $rver"
	echo

	if [ "$dver" != "$rver" ]; then
		echo "Updating to ${rver} ..." 

		sed -i -e "s/$dver/$rver/" ".github/workflows/${prog}.yml" && \
		git add ".github/workflows/${prog}.yml" && \
		git commit -m "Updated ${prog} to ${rver}"

	else
		echo "No update needed ..."
	fi

	echo
	echo
	echo
done

# Make it so
git push
