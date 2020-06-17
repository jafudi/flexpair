#!/usr/bin/env bash

packer build \
        -only=lubuntu-desktop \
        -on-error=abort \
        packer-desktop/oracle-cloud-free-setup.json

