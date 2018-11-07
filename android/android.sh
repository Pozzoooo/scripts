#!/bin/bash

#set -x
set -e

if [[ -z $1 ]]; then
  	echo "say me what"
	exit
fi;

#current script directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/input.sh

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
		tab)
			tab
			;;
#Media
		volUp|vup|louder|vu)
			volumeUp $2
			;;
		volDown|vdown|vd)
			volumeDown $2
			;;
		volMute|volmute|mute|vm)
			volumeMute
			;;
		play|pause|pp|vp)
			mediaPlayPause
			;;
		next|skip|vn|vs)
			mediaNext
			;;
#Connection
	        connect)
	                connect
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
		doze)
			forceDoze
			;;
		dozeOff)
			dozeOff
			;;
		demo)
			demoMode $1
			;;
#Intent
		start|url|open)
			startUrl $2
			;;
		startActivity|activity)
			startActivity $2
			;;
		startAction)
			startAction $2 $3 $4 $5
			;;
		install)
			install $2
			;;
		uninstall)
			uninstall $2
			;;
#Record
		record)
			record $2
			;;
		pullVideo|saveVideo)
			pullVideo $2
			;;
#File
		pull)
			pull $2
			;;
#Tools
		apps)
			listAllApps
			;;
		apkInterface)
			dumpApkInterface $2
			;;
		opened)
			openedActivity
			;;
		kill)
			adbKill $2
			;;
		restartAdb|restart|killAdb)
			restartAdb
			;;
#Error
	        *)
	                echo "Unknown command"
	                ;;
	esac
}

# ----- Tools ------
function listAllApps() {
	adb shell 'pm list packages -f'
}

function dumpApkInterface() {
	aapt dump badging $1
}

function openedActivity() {
	adb shell dumpsys window windows | grep -E 'mCurrentFocus|mFocusedApp'
}

function adbKill() {
	adb shell am kill $1
}

#they are more examples actually, you need to find the commands on sdk tools folder
function oldSdkList() {
	android list sdk --all
}

function oldSdkUpdate() {
	android update sdk -u -a -t "package no."
}

# ----- Record -----
function record() {
	adb shell screenrecord /sdcard/$1
}

function pullVideo() {
	pull /sdcard/$1
}

# ----- File -----
function pull() {
	adb pull $1
}

# ----- Sign -----
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

function forceDoze() {
	adb shell dumpsys deviceidle force-idle
}

function dozeOff() {
	adb shell dumpsys deviceidle unforce
}

#// display time 12:00
#adb shell am broadcast -a com.android.systemui.demo -e command clock -e hhmm 1200
#// Display full mobile data without type
#adb shell am broadcast -a com.android.systemui.demo -e command network -e mobile show -e level 4 -e datatype false
#// Hide notifications
#adb shell am broadcast -a com.android.systemui.demo -e command notifications -e visible false
#// Show full battery but not in charging state
#adb shell am broadcast -a com.android.systemui.demo -e command battery -e plugged false -e level 100
#to exit demo -> adb shell am broadcast -a com.android.systemui.demo -e command exit
function demoMode() {
	adb shell settings put global sysui_demo_allowed $1
}

# ------- Intent ------

function startUrl() {
	adb shell am start $1
}

function startActivity() {
	adb shell am start -n $1
}

#adb shell am start -a "android.intent.action.SEND" --es "android.intent.extra.TEXT" "Hello World" -t "text/plain"
function startAction() {
	adb shell am start -a $1 -es $2 $3 -t $4
}

#seems like we can add unlimited extras:
#adb shell am start -n com.example.mike.app/.SimpleActivity --es "Message" "hello!"
#or
#am start -a android.intent.action.VIEW -c android.intent.category.DEFAULT -e foo bar -e bert ernie -n my.package.component.blah

function install() {
	adb install -r -t "$1"
}

function uninstall() {
	echo "$1"
	adb uninstall "$1"
}

function restartAdb() {
	adb kill-server
	adb start-server
}

main "$@"

