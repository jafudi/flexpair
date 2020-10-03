#!/usr/bin/env bash

echo "Running script office-applications.sh..."
echo

sudo -E apt-get install -y --no-install-recommends --upgrade \
gnumeric gnumeric-plugins-extra gnumeric-doc \
inkscape \
gimp \
kmag \
simplescreenrecorder \
qtqr \
locales \
kdialog elementary-icon-theme \
falkon \
variety \
gnome-clocks \
persepolis aria2 \
backintime-qt
