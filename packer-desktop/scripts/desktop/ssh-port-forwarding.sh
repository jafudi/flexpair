#!/usr/bin/env bash

cat << EOF > /etc/systemd/system/ssh-tunnel.service
[Unit]
Description=Reverse SSH connection
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/ssh -vvv -g -N -T -o "ServerAliveInterval 10" -o "ExitOnForwardFailure yes" -o "StrictHostKeyChecking no" -i /var/tmp/ssh/vm_key -R 5900:localhost:5900 -R 6667:localhost:667 -R 2222:localhost:22 -R 4713:localhost:4713 ubuntu@tryno4.theworkpc.com
Restart=always
RestartSec=5s

[Install]
WantedBy=default.target
EOF
systemctl enable ssh-tunnel.service
