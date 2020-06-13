#!/usr/bin/env bash

curl http://www.berghalde.com/picam/capt0000.jpg -o berghalde-heidelberg.jpg
QT_QPA_PLATFORM=offscreen pcmanfm-qt --set-wallpaper=berghalde-heidelberg.jpg --wallpaper-mode=stretch
