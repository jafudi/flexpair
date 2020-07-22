#!/usr/bin/env bash

packer build \
        -var "ssl_sub_domain=tryno2.theworkpc.com" \
        -on-error=abort \
        packer-desktop/oracle-cloud-free-setup.json