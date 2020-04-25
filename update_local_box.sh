#!/usr/bin/env bash

# https://packer.io/docs/builders/virtualbox-iso.html
packer build -force -only=virtualbox-iso packer-desktop/ubuntu/pack-lubuntu.json
vagrant box remove --all Jafudi/ludopy
vagrant box add --clean --force Jafudi/ludopy packer-desktop/builds/lubuntu-docker-python.virtualbox.box
