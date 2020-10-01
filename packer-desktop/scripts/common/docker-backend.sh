#!/bin/bash -eux

sudo apt-get update
export DEBIAN_FRONTEND=noninteractive
sudo -E apt-get install -y --no-install-recommends docker.io git
sudo systemctl enable --now docker
sudo usermod -aG docker ubuntu

url="https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)"
sudo curl --silent -L ${url} -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

