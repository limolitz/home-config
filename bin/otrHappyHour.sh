#!/bin/bash
cat /home/florin/scripts/otr_happyHour.txt | while read line; do
   /bin/echo "Downloading $line"
   /usr/bin/aria2c $line -d /media/hdd/aria2 -m 0 --retry-wait=30 --auto-file-renaming=false --on-download-complete=
done
#/bin/rm /home/florin/scripts/otr_happyHour.txt

