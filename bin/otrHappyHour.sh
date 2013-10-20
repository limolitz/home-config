#!/bin/bash
dataFile="/home/florin/bin/otr_happyHour.txt"
tmpFile="/home/florin/bin/otr_happyHour_new.txt"

cat $dataFile | while read line; do
   /bin/echo "Downloading $line"
   /usr/bin/aria2c $line -d /tmp -m 0 --retry-wait=30 --auto-file-renaming=false --on-download-complete= >/dev/null
   download=$?
   case $download in
   	0)
				echo "$line downloaded."
				grep -v "$line" $dataFile > $tmpFile
				/bin/rm $dataFile
				mv $tmpFile $dataFile
				;;
   	1)
        echo "Error: unknown error"
        ;;
    2)
     		;;
    3)

        ;;
    13)
				echo "File already exists."
				;;
    18)
     		echo "Error: aria2 could not create directory."
     		;;
    *)
        echo "Error: $line not downloaded. Unhandled status $download"
        ;;
    esac
done

#/bin/rm /home/florin/scripts/otr_happyHour.txt

