#!/bin/bash

# @author Luiz Gustavo Pozzo
# @since 14/11/2016

set -e
#set -x

if [[ -z $1 ]]; then
	echo "say me what";
	exit;
fi;

function main() {
	case $1 in
	        net|network|wifi)
                	restartNetwork
        	        ;;
	        up|upgrade|update)
        	        updateUpgrade
	                ;;
		gitPullFolder|pull)
			gitPullFolder
			;;
		brith)
			screenBrithness $2 $3
			;;
		scan)
			scan "$2"
			;;
		shDir)
			shDir
			;;
		gateway)
			gateway
			;;
		gStUser)
			gitStatusByUser
			;;
		countDown)
			countDown $2
			;;
		refreshClock|clock)
			refreshClock
			;;
		bumblebeeSettings)
			optirun -b none nvidia-settings -c :8
			;;
        	*)
	                echo "Look at the script file to see the avaialble commands, aint gonna print myself :P"
	esac
}

function scan() {
	sudo arp-scan -l | grep -i "$1"
	#Others ways to do the same:ç
	#nmap -sn 172.24.227.0/24 | grep -i -B 4 "68:f7:28:52:ee:3f"
	#arp-scan --interface=$2 --localnet
}

#An even beter tool: https://github.com/arzzen/git-quick-stats
function gitStatusByUser() {
	git log --author="$1" --pretty=tformat: --numstat \
		| gawk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "added lines: %s removed lines: %s total lines: %s\n", add, subs, loc }' -
}

function gateway() {
	ip route | grep default
}

function shDir() {
	echo "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
}

function motherboardInfo() {
	sudo dmidecode -t2
}

function screenBrithness() {
	case $2 in
		xfce)
			xbacklight $1
			;;
		*)
			sudo su -c "echo $1 > /sys/class/backlight/*/brightness"
			;;
	esac
}


function gitPullFolder() {
	ls | xargs -I X sh -c "echo X; cd X; git pull; cd ..; echo ''; echo ''"
}

function restartNetwork() {
	service network-manager restart;
}

function startAndroidStudio() {
	./dev/android-studio/bin/studio.sh;
}

function backupXfceConfig() {
	cp /media/xalien/67fd4c7b-df4b-42fb-90fd-2436e502f423/home/barrador/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml .
	cp /media/xalien/67fd4c7b-df4b-42fb-90fd-2436e502f423/home/barrador/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml .
	cp /media/xalien/67fd4c7b-df4b-42fb-90fd-2436e502f423/home/barrador/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml .
	cp /media/xalien/67fd4c7b-df4b-42fb-90fd-2436e502f423/home/barrador/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-power-manager.xml .
	cp /media/xalien/67fd4c7b-df4b-42fb-90fd-2436e502f423/home/barrador/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-session.xml .
	cp /media/xalien/67fd4c7b-df4b-42fb-90fd-2436e502f423/home/barrador/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml .
}

function updateUpgrade() {
	apt-get update && sudo apt-get -y upgrade;
}

function installBasicPacks() {
	apt-get -y install vim htop iftop iotop git xclip;
}

function installJDKi() {
	apt-get -y install lib32z1 lib32ncurses5 lib32stdc++6;
	apt-get -y install openjdk-8-doc openjdk-8-jdk openjdk-8-source icedtea-8-plugin openjdk-8-dbg;
}

function setupGit() {
	ssh-keygen;
	cat ~/.ssh/id_rsa.pub | xclip -sel clip;
	git config --global user.name "Luiz Gustavo Pozzo"
	git config --global user.email "luiz.pozzo@gmail.com"
}

function setupDevEnviorment() {
	mkdir ~/dev;
	mkdir ~/dev/projs;
	mkdir ~/dev/sdk;
	mkdir ~/android-studio;
}

function setupDevMachine() {
	updateUpgrade;
	installBasicPacks;
	installJDK;
	setupDevEnviorment;
	setupGit;
}

function diskBenchmark() {
	hdparm -tT /dev/sda5;
	dd if=/dev/zero of=/tmp/output bs=8k count=1000k; rm -f /tmp/output;
}

function countDown() {
	for (( i=$1; i>0; --i )); do 
		echo $i
		sleep 1
		tput cuu1
		tput el
	done
}

function refreshClock() {
	sudo ntpdate -s time.nist.gov
}

main "$@"

