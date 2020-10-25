#!/usr/bin/env bash

mkdir -p /home/ubuntu/uploads
chown -R ubuntu /home/ubuntu

cat << EOF > /home/ubuntu/.ssh/vm_key
${VM_PRIVATE_KEY}
EOF
chmod 600 /home/ubuntu/.ssh/vm_key

