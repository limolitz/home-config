#!/bin/bash
inFile="/home/florin/bin/otr.txt"
outFile="/home/florin/bin/otr_grep.txt"
happyHourFile="/home/florin/bin/otr_happyHour.txt"
/home/florin/scripts/dropbox_uploader.sh download Projekte/otr2torrent/mails.txt $inFile
# Grep nach Torrent-Datei als Anhang
/bin/grep -oP "filename=.*otrkey" $inFile | /bin/grep -oP "=.*" | /bin/grep -oP "[^=]*.otrkey$" >> $outFile
# Grep nach Torrent-Link per Merkliste
/usr/bin/tr -d '=\n' < $inFile | /bin/grep -oP '"http://81.95.11.2.*xbt_torrent_create.php[^"]*[a-z]"' | /bin/grep -oP "3D.*otrkey" | /bin/grep -oP '[^3D].*' >> $outFile
# Grep nach Direktdownloadlinks fuer HappyHour-Skript
/bin/grep -oP "http://81.95.11.22.*.otrkey" $inFile >> $happyHourFile
# Grep nach Dateiname aus DDL damit auch diese zum Torrent hinzugefuegt werden koennen
/bin/grep -oP "http://81.95.11.22.*.otrkey" otr.txt | grep -oP "[^/]*otrkey" >> $outFile
cat $outFile | while read line; do
   # grep date from file
   date=$(/bin/echo $line | egrep -o "[0-9]{2}\.[0-9]{2}\.[0-9]{2}")
   /bin/echo "Adding $line (with date $date) to torrent"
   /usr/bin/transmission-remote localhost -a "http://81.95.11.2/torrents/$date/$line.torrent"
   #/usr/bin/transmission-remote localhost -a "http://otr.dwolp.de/torrent_dl.php?datei=$line"
done
#/home/florin/scripts/otrAddSecondTracker.sh
#/bin/echo "" > $inFile
#/home/florin/scripts/dropbox_uploader.sh upload $inFile Projekte/otr2torrent/mails.txt
/bin/rm $outFile
#/bin/rm $inFile



