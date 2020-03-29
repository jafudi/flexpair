#!/usr/bin/env bash

# https://packer.io/docs/builders/virtualbox-iso.html
packer build -only=virtualbox-iso packer-desktop/ubuntu/pack-lubuntu.json
