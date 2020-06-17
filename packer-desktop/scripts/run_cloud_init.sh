#!/usr/bin/env bash

echo "Wait for cloud-init to finish..."
cloud-init status --long --wait
cloud-init collect-logs
tar -xzf cloud-init.tar.gz
rm -f cloud-init.tar.gz
cd cloud-init-logs*
cat /var/log/cloud-init-output.log
cd ..
