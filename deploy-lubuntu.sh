#!/usr/bin/env bash

DATE_WITH_TIME=`date "+%Y%m%d-%H%M%S"`
packer build \
        -var "instance_suffix=${DATE_WITH_TIME}" \
        -only=lubuntu-desktop \
        -on-error=abort \
        packer-desktop/oracle-cloud-free-setup.json

