#!/usr/bin/env bash

# https://docs.cloud.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm

mkdir -p .oci
openssl genrsa -out .oci/oci_api_key.pem -aes128 2048
chmod go-rwx .oci/oci_api_key.pem
openssl rsa -pubout -in .oci/oci_api_key.pem -out .oci/oci_api_key_public.pem
openssl rsa -pubout -outform DER -in .oci/oci_api_key.pem | openssl md5 -c