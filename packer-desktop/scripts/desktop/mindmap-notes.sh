#!/usr/bin/env bash

echo "Running script mindmap-notes.sh..."
echo

sudo -E apt-get install -y --upgrade \
vym knotes basket \
focuswriter hunspell hunspell-tools hunspell-de-de
