#!/usr/bin/env bash

packer build -only=virtualbox-iso packer-desktop/ubuntu/pack-lubuntu.json
