#!/bin/bash -eux

echo "Running script multiple-languages.sh..."
echo

export DEBIAN_FRONTEND="noninteractive"

sudo -E apt-get -qq install --install-recommends  \
language-pack-ja fonts-takao-mincho \
fcitx-mozc fcitx-config-gtk

sudo -E apt-get -qq install --install-recommends  \
language-pack-de
