#!/bin/bash

CHOICE="$(termux-dialog radio -v "Video only,Audio only,Video and audio" -t "Select format:" | grep index | tr -d -c 0-9 &)"

if [ "$CHOICE" = 0 ]
then
    youtube-dl -o "/data/data/com.termux/files/home/storage/shared/Youtube/video/%(title)s.%(ext)s" $1
elif [ "$CHOICE" = 1 ]
then
    youtube-dl -o "/data/data/com.termux/files/home/storage/shared/Youtube/audio/%(title)s.%(ext)s" -f 140 $1 
else
    youtube-dl -o "/data/data/com.termux/files/home/storage/shared/Youtube/video/%(title)s.%(ext)s" $1
    youtube-dl -o "/data/data/com.termux/files/home/storage/shared/Youtube/audio/%(title)s.%(ext)s" -f 140 $1
fi

    
