#!/bin/bash

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

function comboTabEnter() {
        while [[ $# -gt 0 ]]; do
                COUNT="$1"
                    
                for i in $(seq 1 $COUNT); do
			printf "$i"
                        tab
                done
                enter
		shift
        done
}

