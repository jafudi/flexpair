#!/bin/sh -eux

echo "Running script networking.sh..."
echo

export DEBIAN_FRONTEND="noninteractive"
sudo -E apt-get -qq install --no-install-recommends \
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
sudo systemctl enable darkstat.service
sudo systemctl start darkstat.service
