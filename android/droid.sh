#!/bin/sh

# meant to be run inside an Android adb shell console
# Created has probably created this script from a Lineage OS

set -e

if [[ -z $1 ]]; then
        echo "say me what"
        exit
fi;

function main() {
        case $1 in
		top)
			top
			;;
                *)
                        echo "Unknown command"
                        ;;
        esac
}

function top() {
	#another great parameter is top -o cpu,res,args
	watch -t -n 7 -e 'top | head -n 10'
}

main "$@"

