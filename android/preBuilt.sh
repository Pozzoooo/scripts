#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/input.sh

if [[ -z PACKAGE ]]; then
	PACKAGE=$2
	exit
fi;
if [[ -z ENVIRONMENT ]]; then
	ENVIRONMENT=$3
	exit
fi;
if [[ -z PACKAGE ]]; then
	BUILD_TYPE=$4
	exit
fi;
if [[ -z PACKAGE ]]; then
	MAIN_ACTIVITY=$5
	exit
fi;

function main() {
	case $1 in
		start)
			start
			;;
	esac
}

function start() {
	bash $DIR/android.sh startActivity "${PACKAGE}.${ENVIRONMENT}.${BUILD_TYPE}/${PACKAGE}.${MAIN_ACTIVITY}"
}

main "$@"

