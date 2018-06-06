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
	>&2 echo "missing $1, sample: $2"
	exit 1
}

if [ -z "$PACKAGE" ]; then
	missing "PACKAGE" "com.cool.project"
fi;
if [ -z "$ENVIRONMENT" ]; then
	missing "ENVIRONMENT" "snapshot"
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
if [ -z "$REMOTE_COMPILE" ]; then
	gradle="./gradlew"
else
	gradle="mainframer ./gradlew"
fi;

FULL_ID="${PACKAGE}.${APPLICATION_ID_SUFFIX}.${BUILD_TYPE}"
ENVIRONMENT_UP="$(tr '[:lower:]' '[:upper:]' <<< ${ENVIRONMENT:0:1})${ENVIRONMENT:1}"
BUILD_TYPE_UP="$(tr '[:lower:]' '[:upper:]' <<< ${BUILD_TYPE:0:1})${BUILD_TYPE:1}"
GRADLE_COMMAND_SUFFIX="${ENVIRONMENT_UP}${BUILD_TYPE_UP}"

function main() {
	debugParams
	while [[ $# -gt 0 ]]; do
		case $1 in
			assemble|ass|a)
				assemble
				;;
			start|st|s)
				start
				;;
			install|inst|i)
				install
				;;
			clean|c)
				clean
				;;
			test|t)
				test
				;;
			uninstall|unins|u)
				uninstall
				;;
			lint)
				lint
				;;
			kill|k)
				killApp
				;;
			what|debug)
				debugParams
				debugBuiltParams
				;;
			*)
				runOnGradle $1
				;;
		esac
	shift
	done
}

function debugParams() {
	echo "
		ENVIRONMENT:	$ENVIRONMENT
		PACKAGE:	$PACKAGE
		BUILD_TYPE:	$BUILD_TYPE
		MAIN_ACTIVITY:	$MAIN_ACTIVITY
		APPLICATION_ID_SUFFIX:$APPLICATION_ID_SUFFIX
		REMOTE_COMPILE:	$REMOTE_COMPILE
	"
}

function debugBuiltParams() {
	echo "
		FULL_ID:		$FULL_ID
		ENVIRONMENT_UP:		$ENVIRONMENT_UP
		BUILD_TYPE_UP:		$BUILD_TYPE_UP
		GRADLE_COMMAND_SUFFIX:	$GRADLE_COMMAND_SUFFIX
	"
}

function clean() {
	eval "$gradle clean"
}

function assemble() {
	eval "$gradle assemble$GRADLE_COMMAND_SUFFIX"
}

function test() {
	eval "$gradle test$GRADLE_COMMAND_SUFFIX"
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

function lint() {
	eval "$gradle lint$GRADLE_COMMAND_SUFFIX"
}

function killApp() {
	"$and" kill "$FULL_ID"
}

function runOnGradle() {
	eval "$gradle $@"
}

main "$@"

