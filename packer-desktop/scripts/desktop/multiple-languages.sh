#!/usr/bin/env bash

echo "Running script multiple-languages.sh..."
echo

export DEBIAN_FRONTEND="noninteractive"

sudo -E apt-get -y install -qq --install-recommends  \
language-pack-ja fonts-takao-mincho \
fcitx-mozc fcitx-config-gtk

sudo -E apt-get -y install -qq --install-recommends  \
language-pack-de
