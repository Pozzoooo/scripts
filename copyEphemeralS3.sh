#!/bin/bash
#
# Really straight forward S3 copy, should run from time to time, but not to often.
# We used this as a Ephemeral backup for non critical files.
# It runs on risk of overriding up to 7 seconds of files.
# It will upload only modified files on given folder, (the find is recursively).
# A huge file upload can use quite much resources, so be careful.
# 
# @since: 27/01/2014
# @author: Luiz Gustavo Pozzo

last_date=`cat /root/scripts_cron/lastIntegracao.dat`;
date=`date +%s`;
echo $date > /root/scripts_cron/lastIntegracao.dat;
date_diff=`expr $date - $last_date + 7`;
date_diff=`expr $date_diff / 60`;

echo $date_diff;

# $1 Folder to be copied.
function copy() {
        echo -e "\t\t\t\tcopying $1";
        cd "/home/ephemeral/$1";
        for file in `find -mmin -$date_diff -type f`;
        do
                /usr/bin/aws s3 cp --region sa-east-1 $file "s3://bucket.name.$1/${file:2}";
        done;
}

copy foldername;
copy foldernamex;
copy foldernamey;

