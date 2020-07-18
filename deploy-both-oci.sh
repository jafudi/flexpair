#!/usr/bin/env bash

packer build \
        -var "ssl_sub_domain=fielenbach.theworkpc.com" \
        -on-error=abort \
        packer-desktop/oracle-cloud-free-setup.json