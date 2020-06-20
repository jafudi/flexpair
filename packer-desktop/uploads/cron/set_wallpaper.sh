#!/usr/bin/env bash

curl http://www.berghalde.com/picam/capt0000.jpg -o berghalde-heidelberg.jpg
# TODO: Crop originating from left bottom corner, use ImageMagick
pcmanfm-qt --desktop-off
rm -f /home/ubuntu/.cache/pcmanfm-qt/default/* # necessary to trigger update of desktop
nohup pcmanfm-qt --desktop --set-wallpaper=berghalde-heidelberg.jpg --wallpaper-mode=stretch &
echo

