#!/usr/bin/env bash

packer build \
        -var "ssl_sub_domain=desktop.jafudi.net" \
        -on-error=abort \
        packer-desktop/oracle-cloud-free-setup.json