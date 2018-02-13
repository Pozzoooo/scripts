#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/input.sh

PACKAGE=$1
ENVIRONMENT=$2
BUILD_TYPE=$3
MAIN_ACTIVITY=$4

function start() {
	bash $DIR/android.sh startActivity "${PACKAGE}.${ENVIRONMENT}.${BUILD_TYPE}/${PACKAGE}.${MAIN_ACTIVITY}"
}

