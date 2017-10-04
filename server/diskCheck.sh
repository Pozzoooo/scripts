#!/bin/bash
#
# Script which will check disk space and send an email if it over the expected ($1).
#
# @author Luiz Gustavo Pozzo
# @since 30/04/2014

if [[ -z $1 ||  -z $2 ]]; then
	echo "
	\$1 Disk space limit, more than this and an email will be sent.
	\$2 A name which will be sent on email to identify this.
	\$3 Disk to be verified (default: xvdf)";
	exit;
fi;

# set default if not given.
if [[ -z $3 ]]; then
	DISC="xvdf";
else
	DISC=$3;
fi;

# Sends the warning message.
function sendMessage() {
	MSG="Disco quase cheio, instancia: $2, % ocupada: $1";
	/root/scripts_cron/email.sh notUrgent "$MSG" "Disco quase cheio $2";
}

# Makes the check with some simple bash commands.
DISCO=`df | grep "\/dev\/$DISC" | awk '{print $5}' | sed -e "s/%//g"`;
if [ "$DISCO" -gt "$1" ]; then
	sendMessage $DISCO $2;
fi;

