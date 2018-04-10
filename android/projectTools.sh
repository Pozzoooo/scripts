#!/bin/bash

set -e
#set -x

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
input="$DIR/input.sh"
and="$DIR/android.sh"
gradle="./gradlew"

if [[ -z $1 ]]; then
	echo "say me what"
	exit
fi;

function missing() {
	>&2 echo "missing $1, sample: $2"
	exit 1
}

if [ -z "$PACKAGE" ]; then
i	missing "PACKAGE" "com.cool.project"
fi;
if [ -z "$ENVIRONMENT" ]; then
	missing "ENVIRONMENT" "snapshot"
	echo "foca"
fi;
if [ -z "$BUILD_TYPE" ]; then
	missing "BUILD_TYPE" "debug"
fi;
if [ -z "$MAIN_ACTIVITY" ]; then
	missing "MAIN_ACTIVITY" "SplashActivity"
fi;
if [ -z "$APPLICATION_ID_SUFFIX" ]; then
	missing "APPLICATION_ID_SUFFIX" "snapshot"
fi;

echo "parameters: PACKAGE:$PACKAGE ENVIRONMENT:$ENVIRONMENT BUILD_TYPE:$BUILD_TYPE MAIN_ACTIVITY:$MAIN_ACTIVITY APPLICATION_ID_SUFFIX:$APPLICATION_ID_SUFFIX"

FULL_ID="${PACKAGE}.${APPLICATION_ID_SUFFIX}.${BUILD_TYPE}"
ENVIRONMENT_UP="$(tr '[:lower:]' '[:upper:]' <<< ${ENVIRONMENT:0:1})${ENVIRONMENT:1}"
BUILD_TYPE_UP="$(tr '[:lower:]' '[:upper:]' <<< ${BUILD_TYPE:0:1})${BUILD_TYPE:1}"

function main() {
#what about a loop and shift commands?
	case $1 in
		assemble)
			assemble
			;;
		start)
			start
			;;
		install)
			install
			;;
		uninstall)
			uninstall
			;;
		kill)
			killApp
			;;
		*)
			echo "whaaaaaaaaaat?"
			exit
	esac
}

function assemble() {
	"$gradle" "assemble${ENVIRONMENT_UP}${BUILD_TYPE_UP}"
}

function start() {
	"$and" startActivity "${FULL_ID}/${PACKAGE}.${MAIN_ACTIVITY}"
}

function install() {
	"$and" install "app/build/outputs/apk/${ENVIRONMENT}/${BUILD_TYPE}/app-${ENVIRONMENT}-${BUILD_TYPE}.apk"
}

function uninstall() {
	"$and" uninstall "$FULL_ID"
}

function killApp() {
	"$and" kill "$FULL_ID"
}

main "$@"

