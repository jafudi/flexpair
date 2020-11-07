#!/bin/sh -eux

if [ ! -f /etc/.terraform-complete ]; then
    echo "Terraform provisioning not yet complete, exiting"
    exit 0
fi

export DEBIAN_FRONTEND="noninteractive"
apt-get -qq install --no-install-recommends \
darkstat \
net-tools \
glances

cat << EOF > /etc/systemd/system/darkstat.service
[Unit]
Description=Network Traffic Visualization in Browser
After=network.target

[Service]
Type=simple
ExecStart=/usr/sbin/darkstat -i ens3 -p 667
Restart=always
RestartSec=5s
StartLimitIntervalSec=0

[Install]
WantedBy=default.target
EOF
systemctl enable darkstat.service
systemctl start darkstat.service
