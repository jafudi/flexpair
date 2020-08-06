#!/bin/bash -eux

apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends docker.io git
systemctl enable --now docker
usermod -aG docker ubuntu

url="https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)"
curl --silent -L ${url} -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

