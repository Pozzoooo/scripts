#!/bin/bash

# @author Luiz Gustavo Pozzo
# @since 14/11/2016

set -e
set -x

if [[ -z $1 ]]; then
	echo "say me what";
	exit;
fi;

function createMyAlias() {
	PATH="`pwd`/$0";
	echo "" >> ~/.bashrc;
	echo "#auto added by pozzo helper" >> ~/.bashrc;
	echo "alias h='$PATH'" >> ~/.bashrc;
	echo "alias helper='$PATH'" >> ~/.bashrc;
	echo "alias pozzo='$PATH'" >> ~/.bashrc;
	echo "alias z='$PATH'" >> ~/.bashrc;
	echo "alias zs='sudo $PATH'" >> ~/.bashrc;
	echo "alias g='./gradlew --daemon --stacktrace'" >> ~/.bashrc;
	echo "alias paste='adb shell input text'" >> ~/.bashrc;
	echo "alias gc='g clean'" >> ~/.bashrc;
	echo "alias l=ls" >> ~/.bashrc;
	echo "alias ll=ls" >> ~/.bashrc;
	echo "alias sl=ls" >> ~/.bashrc;
	echo "#end auto added" >> ~/.bashrc;
	echo "now run: source ~/.bashrc";
}

function restartNetwork() {
	service network-manager restart;
}

function startAndroidStudio() {
	./dev/android-studio/bin/studio.sh;
}

function backupXfceConfig() {
	cp ~/config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml ~/.;
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

case $1 in
	live)
		createMyAlias;
		;;
	net|network|wifi)
		restartNetwork;
		;;
	up|upgrade|update)
		updateUpgrade;
		;;
	*)
		echo "Look at the final of the script file to see the avaialble commands, aint gonna print myself :P";
esac

