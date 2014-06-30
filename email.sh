#!/bin/bash
#
# This script has the only intention to centralize any sns message sent.
#
# @author Luiz Gustavo Pozzo
# @since 30/04/2014

# little help if needed
if [[ -z $1 ||  -z $2 ]]; then
	echo "
	\$1 Endpoint: watchdog, billing, notUrgent, test.
	\$2 Message to be sent.
	\$3 Message title.";
	exit;
fi;

function sendEmail() {
	/usr/bin/aws sns publish --topic-arn "$1" --subject "$2" --message "$3" --region $4;
}

# If title is not present, we make it the instance-id.
if [[ -z $3 ]]; then
	TITLE="`/usr/bin/curl -s http://169.254.169.254/latest/meta-data/instance-id`";
else
	TITLE=$3;
fi;

case $1 in
	watchdog)
		sendEmail "arn:aws:sns:sa-east-1:000000000000:watchdog" "$TITLE" "$2" "sa-east-1";
		;;
	billing)
		sendEmail "arn:aws:sns:us-east-1:000000000000:Billing" "$TITLE" "$2" " us-east-1";
		;;
	notUrgent)
		sendEmail "arn:aws:sns:sa-east-1:000000000000:notUrgent" "$TITLE" "$2" "sa-east-1";
		;;
	*)
		sendEmail "arn:aws:sns:sa-east-1:000000000000:testTopic" "$TITLE" "$2" "sa-east-1";
		;;
esac

