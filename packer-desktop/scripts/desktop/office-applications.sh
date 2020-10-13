#!/usr/bin/env bash

echo "Running script office-applications.sh..."
echo

export DEBIAN_FRONTEND="noninteractive"

sudo -E apt-get -qq install --no-install-recommends  \
gnumeric gnumeric-plugins-extra gnumeric-doc \
inkscape \
gimp \
kmag \
simplescreenrecorder \
locales \
kdialog elementary-icon-theme \
falkon \
gnome-clocks \
persepolis aria2
