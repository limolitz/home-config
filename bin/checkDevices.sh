#!/bin/bash
# insert either IP adresses or hostnames as defined in your ~/.ssh/config
devices=("raspbmc" "netpi" "kiwiPC" "192.168.1.54" "192.168.1.45")
names=("raspbmc" "netpi" "kiwiPC" "Desire" "Galaxy Tab")
#for device in "${devices[@]}"
for (( i = 0 ; i < ${#devices[@]} ; i++ ))
do
	device=${devices[$i]}
	name=${names[$i]}
	if ssh "$device" true > /dev/null 2>&1; then
  	echo "$name is online" >&2
	else
		# ssh not working, try ping
		# get IP of server
		ip=$(ssh -v "$device" true 2>&1 | egrep -o "^debug1: Connecting to ([1-9]{1,3}\.){3}[1-9]{1,3}" | egrep -om 1 "([1-9]{1,3}\.){3}[1-9]{1,3}");
		#echo "Trying to ping $ip"
		if ping -c 1 $ip > /dev/null; then
			echo "$name is online" >&2
		else
			echo "$name is offline" >&2
		fi
	fi
done