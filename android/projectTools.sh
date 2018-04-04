#!/bin/bash

set -e
set -x

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
input="$DIR/input.sh"
and="$DIR/android.sh"

function missing() {
	>&2 echo "missing $1"
	exit 1
}

if [ -z "$PACKAGE" ]; then
	missing "PACKAGE"
fi;
if [ -z "$ENVIRONMENT" ]; then
	missing "ENVIRONMENT"
	echo "foca"
fi;
if [ -z "$BUILD_TYPE" ]; then
	missing "BUILD_TYPE"
fi;
if [ -z "$MAIN_ACTIVITY" ]; then
	missing "MAIN_ACTIVITY"
fi;

echo "parameters: PACKAGE:$PACKAGE ENVIRONMENT:$ENVIRONMENT BUILD_TYPE:$BUILD_TYPE MAIN_ACTIVITY:$MAIN_ACTIVITY"

function main() {
	case $1 in
		start)
			start
			;;
	esac
}

function start() {
	"$and" startActivity "${PACKAGE}.${ENVIRONMENT}.${BUILD_TYPE}/${PACKAGE}.${MAIN_ACTIVITY}"
}

main "$@"

