#!/usr/bin/env bash

apt-get update

echo "\n\nInstall Python packages required for testing on guest OS..."
DEBIAN_FRONTEND=noninteractive apt-get install --upgrade -y --no-install-recommends python3-pip
pip3 install setuptools
pip3 install behave jsonschema tinydb invoke

echo "\n\nInstall Gitlab Runnner for uploading artifacts from guest VM..."
curl --silent -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash
DEBIAN_FRONTEND=noninteractive apt-get install --upgrade -y gitlab-runner

echo 'gitlab-runner ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
usermod -aG docker gitlab-runner

mkdir -p builds
chmod --recursive 777 builds
rm -f .bash_logout



