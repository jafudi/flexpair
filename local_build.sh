#!/usr/bin/env bash

# https://packer.io/docs/builders/virtualbox-iso.html
packer build -force -only=virtualbox-iso packer-desktop/ubuntu/pack-lubuntu.json
