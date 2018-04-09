#!/bin/bash

set -e
#set -x

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
input="$DIR/input.sh"
and="$DIR/android.sh"

if [[ -z $1 ]]; then
	echo "say me what"
	exit
fi;

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
if [ -z "$APPLICATION_ID_SUFFIX" ]; then
	missing "APPLICATION_ID_SUFFIX"
fi;

echo "parameters: PACKAGE:$PACKAGE ENVIRONMENT:$ENVIRONMENT BUILD_TYPE:$BUILD_TYPE MAIN_ACTIVITY:$MAIN_ACTIVITY APPLICATION_ID_SUFFIX:$APPLICATION_ID_SUFFIX"

function main() {
	case $1 in
		start)
			start
			;;
		install)
			install
			;;
		uninstall)
			uninstall
			;;
		*)
			echo "whaaaaaaaaaat?"
			exit
	esac
}

function start() {
	"$and" startActivity "${PACKAGE}.${APPLICATION_ID_SUFFIX}.${BUILD_TYPE}/${PACKAGE}.${MAIN_ACTIVITY}"
}

function install() {
	"$and" install "app/build/outputs/apk/${ENVIRONMENT}/${BUILD_TYPE}/app-${ENVIRONMENT}-${BUILD_TYPE}.apk"
}

function uninstall() {
	"$and" uninstall "$PACKAGE.$APPLICATION_ID_SUFFIX.$BUILD_TYPE"
}

main "$@"

