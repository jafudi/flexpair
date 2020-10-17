#!/usr/bin/env bash

echo "Running script mindmap-notes.sh..."
echo

export DEBIAN_FRONTEND="noninteractive"

sudo -E apt-get -qq install --no-install-recommends vym

sudo -E apt-get -qq install --no-install-recommends knotes

sudo -E apt-get -qq install --no-install-recommends \
focuswriter \
hunspell hunspell-tools hunspell-de-de
