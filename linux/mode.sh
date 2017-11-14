#!/bin/bash

DIR=`dirname $0`
hlp="$DIR/helper.sh"

function main() {
	case $1 in
		night|nit)
			night
			;;
		morning|mrn)
			morning
			;;
		*)
			echo "looking for a new mode?"
			;;
	esac
}

function night() {
	$hlp brith 1
	amixer set Master 65%
}

function morning() {
	$hlp brith 1500
	amixer set Master 50%
}

main "$@"

