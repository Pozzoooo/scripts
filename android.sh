#!/bin/bash

#set -x
set -e

if [[ -z $1 ]]; then
  	echo "say me what"
	exit
fi;

function main() {
	case $1 in
#Sign
	        zipalign)
	                zipalign $2 $3
	                ;;
	        sign)
	                sign $2 $3
	                ;;
#Input
	        sample)
	                sampleScript
	                ;;
		text|i|input)
			text "$2"
			;;
		key)
			key $2
			;;
		backspace|del)
			backspace
			;;
		enter)
			enter
			;;
		volUp|vup|louder)
			volumeUp $2
			;;
		volDown|vdown)
			volumeDown $2
			;;
		volMute|volmute|mute)
			volumeMute
			;;
		play|pause|pp)
			mediaPlayPause
			;;
		next|skip)
			mediaNext
			;;
#Connection
	        connect)
	                connect $1 $2
	                ;;
		ip)
			deviceIp
			;;
		wifyKeyboard|wk)
			wifiKeyboardDefaultUrl
			;;
#Debug
		dump)
			dump
			;;
#Error
	        *)
	                echo "Unknown command"
	                ;;
	esac
}

function align() {
	zipalign -v -p 4 $1 $2;
}

function sign() {
	KEY_ALIAS = `grep "keyAlias" keystore.properties | awk -F "=" '{print $2}').trim()`;
	STORE_PASSWORD = `grep "storePassword" keystore.properties | awk -F "=" '{print $2}').trim()`;
	KEY_PASSWORD = `grep "keyPassword" keystore.properties | awk -F "=" '{print $2}').trim()`;
	apksigner sign --ks keystore.jks --ks-key-alias $KEY_ALIAS --ks-pass pass:$STORE_PASSWORD --key-pass pass:$KEY_PASSWORD --out $1 $2;
}

# ----- Connection -----

function connect() {
	PORT=9900
        IP=`deviceIp`
	adb -d tcpip $PORT
        adb -d connect $IP:$PORT
}

function deviceIp() {
	adb -d shell ip route | awk {'if( NF >=9){print $9;}'} #maybe alternative: adb shell netcfg
}

function wifiKeyboardDefaultUrl() {
	IP=`deviceIp`
	echo "http://$IP:7777"
}

# ------ Debug ------

function dump() {
	adb bugreport
}

# ------- Input ------

function key() {
        adb shell input keyevent $1
}

function text() {
	TEXT=`echo "$1" | sed "s/ /%s/g"`
        adb shell input text "$TEXT"
}

function volumeUp() {
	for i in $(seq 1 $1); do
		key 24 &
	done
}

function volumeDown() {
	for i in $(seq 1 $1); do
		key 25 &
	done
}

function tab() {
        key 61
}

function enter() {
        key 66
}

function backspace() {
	key 67
}

function mediaPlayPause() {
	key 85
}

function mediaNext() {
	key 87
}

function volumeMute() {
	key 164
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

main "$@"

