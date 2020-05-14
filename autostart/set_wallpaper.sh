#!/usr/bin/env bash

# https://manpages.ubuntu.com/manpages/focal/en/man1/pcmanfm-qt.1.html
pcmanfm-qt --desktop-off
pcmanfm-qt --desktop --set-wallpaper=/usr/share/lubuntu/wallpapers/2004-lubuntu-logo.png --wallpaper-mode=stretch
xrandr -s 1360x768