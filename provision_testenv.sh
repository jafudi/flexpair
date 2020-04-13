#!/usr/bin/env bash

apt-get update

echo "\n\nInstall Python packages required for testing on guest OS..."
DEBIAN_FRONTEND=noninteractive apt-get install --upgrade -y --no-install-recommends python3-pip
pip3 install setuptools
pip3 install behave jsonschema tinydb invoke

echo "\n\nInstall Gitlab Runnner for uploading artifacts from guest VM..."
DEB_FILE="gitlab-runner_amd64.deb"
curl -LJO https://gitlab-runner-downloads.s3.amazonaws.com/latest/deb/${DEB_FILE}
dpkg -i ${DEB_FILE}
rm -f ${DEB_FILE}

mkdir -p builds
chmod --recursive 777 builds

rm -f .bash_logout

DEBIAN_FRONTEND=noninteractive apt-get install --upgrade -y --no-install-recommends featherpad
