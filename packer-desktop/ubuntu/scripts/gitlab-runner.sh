#!/bin/sh -eux

DEBIAN_FRONTEND=noninteractive

apt-get update

echo "\n\nInstall Python packages required for testing on guest OS..."
apt-get install --upgrade -y --no-install-recommends python3-pip
pip3 install setuptools
pip3 install behave invoke jsonschema

echo "\n\nInstall Gitlab Runnner for uploading artifacts from guest VM..."
curl --silent -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash
apt-get install --upgrade -y gitlab-runner traceroute

echo 'gitlab-runner ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
usermod -aG docker gitlab-runner

mkdir -p builds
chmod --recursive 777 builds
rm -f .bash_logout



