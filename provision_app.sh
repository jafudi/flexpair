#!/usr/bin/env bash

docker pull jafudi/idea-extractor:latest

DEBIAN_FRONTEND=noninteractive apt-get install --upgrade -y --no-install-recommends kdialog

# Create run script on desktop