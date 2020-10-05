#!/bin/bash -eux

echo "Running script docker-backend.sh..."
echo

sudo apt-get update
export DEBIAN_FRONTEND="noninteractive"
sudo -E apt-get -y install -qq --no-install-recommends docker.io git
sudo systemctl enable --now docker
sudo usermod -aG docker ubuntu

url="https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)"
sudo curl --silent -L ${url} -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

