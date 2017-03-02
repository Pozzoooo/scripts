#!/bin/bash

set -e
set -x

if [[ -z $1 ]]; then
  	echo "say me what";
	exit;
fi;

function align() {
	zipalign -v -p 4 $1 $2;
}

function sign() {
	KEY_ALIAS = `grep "keyAlias" keystore.properties | awk -F "=" '{print $2}').trim()`;
	STORE_PASSWORD = `grep "storePassword" keystore.properties | awk -F "=" '{print $2}').trim()`;
	KEY_PASSWORD = `grep "keyPassword" keystore.properties | awk -F "=" '{print $2}').trim()`;
	apksigner sign --ks keystore.jks --ks-key-alias $KEY_ALIAS --ks-pass pass:$STORE_PASSWORD --key-pass pass:$KEY_PASSWORD --out $1 $2;
}

# $1 IP
# $2 Port
function connect() {
        adb -d tcpip $2
        adb -d connect $1:$2
}

function key() {
        adb shell input keyevent $1
}

function text() {
        adb shell input text $1
}

function tab() {
        key 61
}

function enter() {
        key 66
}

function sampleScript() {
        text Luiz
        tab 
        text Gustavo
        tab 
        text Pozzo
        tab 
        enter
        tab 
        tab 
        enter
        enter
        tab 
        enter
        enter
        tab 
        text 1990
        tab 
        tab 
        tab 
        text 3232323232
        tab 
        tab 
        text luiz.pozzo@mttnow.com
        tab 
        tab 
        enter
        tab 
        tab 
        tab 
        tab 
        enter
}

case $1 in
	zipalign)
		zipalign $2 $3;
		;;
	sign)
		sign $2 $3;
		;;
        sample)
                sampleScript;
                ;;
        connect)
                connect $1 $2;
                ;;
	*)
		echo "Unknown command";
		;;
esac
