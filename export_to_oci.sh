#!/usr/bin/env bash

VBoxManage cloudprofile --provider=OCI --profile=jafudi add --clouduser=ocid1.user.oc1..aaaaaaaaltvig4z3n5ycfbsjbqe2ugsjenazybowblc7m6ih3uv2mt5opexa --fingerprint=15:b0:eb:db:8c:3d:e3:f0:36:97:fa:ee:23:89:7e:c0 --keyfile=~/.oci/oci_api_key.pem --passphrase=jafudi --tenancy=ocid1.tenancy.oc1..aaaaaaaaakxiynnr4tmlxjrwkvqyy7iadh7rvmvhrzxhvtufxsbcfbwks6ja --region=eu-frankfurt-1 --compartment=ocid1.compartment.oc1..aaaaaaaav67tty2zgsxea55juuni7q5uocaavgsrnimz3br3i2nhtyutltja

# insert actual export code