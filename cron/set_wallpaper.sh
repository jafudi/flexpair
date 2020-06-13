#!/usr/bin/env bash

curl http://www.berghalde.com/picam/capt0000.jpg -o berghalde-heidelberg.jpg
pcmanfm-qt --set-wallpaper=berghalde-heidelberg.jpg --wallpaper-mode=stretch
