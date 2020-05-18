#!/usr/bin/env bash

python3 tools/make-mime.py \
-a user-data-parts/cloud-config.yaml:cloud-config \
-a user-data-parts/update_release.sh:x-shellscript \
-a user-data-parts/include-once:x-include-once-url \
-a user-data-parts/always-include:x-include-url \
> seed-from/user-data
