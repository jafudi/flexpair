#!/usr/bin/env bash

echo "Running script office-applications.sh..."
echo

export DEBIAN_FRONTEND="noninteractive"

sudo -E apt-get -y install -qq --no-install-recommends  \
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
