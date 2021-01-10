#!/bin/sh
sudo cp 70-android.rules /etc/udev/rules.d/70-android.rules
sudo chmod 644 /etc/udev/rules.d/70-android.rules
sudo chown root. /etc/udev/rules.d/70-android.rules
sudo service udev restart
sudo killall adb
 
