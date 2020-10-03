#!/usr/bin/env bash

echo "Running script multiple-languages.sh..."
echo

sudo -E apt-get install -y --install-recommends --upgrade \
language-pack-ja fonts-takao-mincho \
fcitx-mozc fcitx-config-gtk

sudo -E apt-get install -y --install-recommends --upgrade \
language-pack-de
