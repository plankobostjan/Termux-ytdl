#!/usr/bin/env bash

apt update && apt upgrade

pkg install termux-api

termux-setup-storage

pkg install python

pip install youtube-dl

mkdir -p /data/data/com.termux/files/home/storage/shared/Youtube/{audio,video}

curl https://raw.githubusercontent.com/plankobostjan/Termux-ytdl/master/config > ~/.config/youtube-dl/config

mkdir -p ~/bin

curl https://raw.githubusercontent.com/plankobostjan/Termux-ytdl/master/termux-url-opener > ~/bin/termux-url-opener

curl https://raw.githubusercontent.com/plankobostjan/Termux-ytdl/master/ytdl.sh > ~/bin/ytdl.#!/bin/sh

chmod +x ~/bin/ytdl.sh ~/bin/termux-url-opener
