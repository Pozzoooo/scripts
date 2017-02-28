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

case $1 in
	zipalign)
		zipalign $2 $3;
		;;
	sign)
		sign $2 $3;
		;;
	*)
		echo "Unknown command";
		;;
esac
