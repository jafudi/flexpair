#!/usr/bin/env bash

packer build \
        -var "ssl_sub_domain=fielenbach.freeddns.org" \
        -on-error=abort \
        packer-desktop/oracle-cloud-free-setup.json