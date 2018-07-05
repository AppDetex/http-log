#!/bin/bash

BASE=`dirname \`readlink -f $0\``
DOCKER_IMAGE=sms-post
CWD=`pwd`

function printTitle {
	echo
	echo //
	echo "// $*"
	echo //
	echo
	sleep 1
}

function processArgs {

	OPTIND=1
	DOCKER_TAG=
	FORCE_REBUILD=0
	SKIP_REBUILD=0

	while getopts "fst:" opt; do
		case "$opt" in
		f)
			FORCE_REBUILD=1
			;;
		s)
			SKIP_REBUILD=1
			;;
		t)
			DOCKER_TAG="$OPTARG"
			;;
		esac
	done

}

function setUmask {

	if [ "X$1" == "X" ]; then
		umask $1 > /dev/null 2>&1
	else
		umask 0027 > /dev/null 2>&1
	fi
}

function pullCode {
	printTitle "Attempting to pull new code"
	git fetch
	if [ "$?" -ne "0" ]; then
		exit -1
	fi

	git status | grep -q 'Your branch is behind'
	if [ "$?" -eq "0" ]; then
		git merge origin/master
		return 1
	fi
	return 0
}

function buildDockerImage {

	printTitle "Building Docker Image $DOCKER_IMAGE"
	docker build -t $DOCKER_IMAGE .
	if [ -n "${DOCKER_TAG}" ]; then
		docker tag $DOCKER_IMAGE:latest $DOCKER_IMAGE:${DOCKER_TAG}
	fi
	
}

processArgs $*

setUmask
if [ "${SKIP_REBUILD}" -eq "0" ]; then
	pullCode
else
	printTitle "Skipping rebuild"
fi

cd "${BASE}"
buildDockerImage
cd "${CWD}"
