#!/bin/bash

set -e
#set -x

#
# todo I need to find a way to group commands, would be much more efficient
# todo another idea, I need to scrape some of the project info from the project actual files, that also would make the command more smart based on the folder you are running it
#

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
	ENVIRONMENT_UP=""
else
	ENVIRONMENT_UP="$(tr '[:lower:]' '[:upper:]' <<< ${ENVIRONMENT:0:1})${ENVIRONMENT:1}"	
fi;
if [ -z "$BUILD_TYPE" ]; then
	missing "BUILD_TYPE" "debug"
fi;
if [ -z "$MAIN_ACTIVITY" ]; then
	missing "MAIN_ACTIVITY" "SplashActivity"
fi;
if [ -z "$APPLICATION_ID_SUFFIX" ]; then
	FULL_ID="${PACKAGE}.${BUILD_TYPE}"
else
	FULL_ID="${PACKAGE}.${APPLICATION_ID_SUFFIX}.${BUILD_TYPE}"	
fi;
if [ "$REMOTE_COMPILE" = false ]; then
	gradle="./gradlew"
else
	gradle="mainframer ./gradlew"
fi;
if [ -z "$APP_FOLDER" ]; then
	APP_FOLDER="app"
fi;


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
		APP_FOLDER:	$APP_FOLDER
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
	local COMMAND="$gradle assemble$GRADLE_COMMAND_SUFFIX"
	echo "$COMMAND"
	eval "$COMMAND"
}

function test() {
	eval "$gradle test$GRADLE_COMMAND_SUFFIX"
}

function start() {
	"$and" startActivity "${FULL_ID}/${PACKAGE}.${MAIN_ACTIVITY}"
}

function install() {
	if [ -z "$ENVIRONMENT" ]; then
		"$and" install "$APP_FOLDER/build/outputs/apk/${BUILD_TYPE}/${APP_FOLDER}-${BUILD_TYPE}.apk"
	else
		"$and" install "$APP_FOLDER/build/outputs/apk/${ENVIRONMENT}/${BUILD_TYPE}/${APP_FOLDER}-${ENVIRONMENT}-${BUILD_TYPE}.apk"
	fi;
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

