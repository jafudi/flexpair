#!/usr/bin/env bash

if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo:"
    echo "sudo $0 $*"
    exit 1
fi

terraform validate
terraform fmt

FILE_NAME="documentation/terraform-graph"
terraform graph -type=validate > "${FILE_NAME}.dot"

# brew install graphviz
dot -Tsvg "${FILE_NAME}.dot" > "${FILE_NAME}.svg"