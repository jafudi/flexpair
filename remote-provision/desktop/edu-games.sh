#!/usr/bin/env bash

echo "Running script edu-games.sh..."
echo

export DEBIAN_FRONTEND="noninteractive"
sudo -E apt-get -qq install --no-install-recommends \
2048-qt \
blockout2 \
kstars \
biniax2 \
blinken \
kmplot kalzium \
cgoban

