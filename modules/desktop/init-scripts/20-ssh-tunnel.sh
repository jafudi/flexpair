#!/usr/bin/env bash

if [ ! -f /etc/.terraform-complete ]; then
    echo "Terraform provisioning not yet complete, exiting"
    exit 0
fi

echo "Bootstrapping using cloud-init..."

# Obtain instance parameters / degrees of freedom ###################

function get_info() {
  curl --silent \
       -H "Authorization: Bearer Oracle" \
       "http://169.254.169.254/opc/v2/instance/$1"
}
export -f get_info

# Configure connection between desktop and gateway #################

cat << EOF > /etc/systemd/system/ssh-tunnel.service
[Unit]
Description=Reverse SSH connection
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/ssh -vvv -g -N -T \
-o ServerAliveInterval=10 \
-o ExitOnForwardFailure=yes \
-o StrictHostKeyChecking=no \
-i /home/ubuntu/.ssh/vm_key \
-R  172.18.0.1:5900:localhost:5900 \
-R  172.18.0.1:4713:localhost:4713 \
-R  172.18.0.1:6667:localhost:667 \
-R  172.18.0.1:2222:localhost:22 \
-L 143:172.18.0.1:143 \
ubuntu@${SSL_DOMAIN}
Restart=always
RestartSec=5s
StartLimitIntervalSec=0

[Install]
WantedBy=default.target
EOF
systemctl enable ssh-tunnel.service
systemctl start ssh-tunnel.service
