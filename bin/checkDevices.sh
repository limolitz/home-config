#!/bin/bash
# insert either IP adresses or hostnames as defined in your ~/.ssh/config
devices=("netpi" "raspbmc" "kiwiPC" "192.168.1.54" "192.168.1.45")
#devices=("netpi")
# insert speaking names which are used in output
names=("netpi" "raspbmc" "kiwiPC" "Desire" "Galaxy Tab")
# filePath for saving state
saveFile="/home/florin/bin/deviceState.txt"
touch $saveFile

# array for file state
previousFileState=("" "" "" "" "")
currentFileState=("" "" "" "" "")

# read previous state
source $saveFile 2>/dev/null

for (( i = 0 ; i < ${#devices[@]} ; i++ ))
do
	device=${devices[$i]}
	name=${names[$i]}
	if ssh "$device" true > /dev/null 2>&1; then
  	echo -n "$name is online, was ${previousFileState[$i]}"
  	currentFileState[$i]="online"
	else
		# ssh not working, try ping
		# get IP of server
		ip=$(ssh -v "$device" true 2>&1 | egrep -o "^debug1: Connecting to ([1-9]{1,3}\.){3}[1-9]{1,3}" | egrep -om 1 "([1-9]{1,3}\.){3}[1-9]{1,3}");
		#echo "Trying to ping $ip"
		if ping -c 1 $ip > /dev/null; then
			echo -n "$name is online, was ${previousFileState[$i]}"
			currentFileState[$i]="online"
		else
			echo -n "$name is offline, was ${previousFileState[$i]}"
			currentFileState[$i]="offline"
		fi
	fi
	if [ "${currentFileState[$i]}" != "${previousFileState[$i]}" ]; then
		echo ", status changed."
	else
		echo ", status unchanged."
	fi
done

# save state in saveFile
echo -n "previousFileState=(" > $saveFile
for i in "${currentFileState[@]}"
do
   echo -n "\"$i\" " >> $saveFile
   # do whatever on $i
done
echo ")" >> $saveFile
