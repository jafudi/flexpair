#!/usr/bin/env bash

echo "Running script multiple-languages.sh..."
echo

export DEBIAN_FRONTEND="noninteractive"

sudo -E apt-get -qq install --install-recommends  \
language-pack-de
