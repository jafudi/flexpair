#!/usr/bin/env bash

packer build \
        -only=guacamole-gateway \
        -var "ssl_sub_domain=jfiely.theworkpc.com" \
        -on-error=abort \
        packer-desktop/oracle-cloud-free-setup.json

