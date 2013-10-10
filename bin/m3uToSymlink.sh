#!/bin/bash
#define folders and files
musicFolder="/home/florin/Musik"
playlistFolder="Wiedergabelisten"
fileArray=("Bessere Hälfte.m3u" "Disco-Mix.m3u")
# "90s.m3u")

# define virtual folder which will be filles with symlinks to all used files
virtualFolder="/home/florin/virtual/Musik"

# empty folder
echo $virtualFolder
rm -irf $virtualFolder/*

# create folder for playlists
mkdir $virtualFolder/Playlists

# fill folder with all used files
for playlist in "${fileArray[@]}"
do
  echo "Read file: $musicFolder/$playlist"
  awk '((NR % 2) != 0 && NR > 1) {print "" $0}' "$musicFolder/$playlistFolder/$playlist" | while read line;
  do
    #echo "$line";
   	# escape whitespaces
    if [ -f "$line" ]
    then
    	# create symlink
      # Todo(fg): Check if file already existing
      ln -f "$line" "$virtualFolder"
    else
      # error
    	echo "The file $line does not exist"
    fi
  done
   #(IFS=$'\n'; ln -sf $(awk '((NR % 2) != 0 && NR > 1) {print "" $0}' "$musicFolder/$i") $virtualFolder)
   # make playlist
   cat "$musicFolder/$playlistFolder/$playlist" | sed "s/$(echo $musicFolder | sed "s/\//\\\\\//g")/../g" > "$virtualFolder/Playlists/$playlist"
done



