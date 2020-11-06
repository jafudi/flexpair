#!/usr/bin/env bash

mkdir -p "/home/${DESKTOP_USERNAME}/.ssh"
cat << EOF > "/home/${DESKTOP_USERNAME}/.ssh/vm_key"
${VM_PRIVATE_KEY}
EOF
chmod 600 /home/ubuntu/.ssh/vm_key

mkdir -p /home/ubuntu/Desktop/Uploads
chown -R ubuntu /home/ubuntu