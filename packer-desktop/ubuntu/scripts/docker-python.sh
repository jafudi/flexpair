#!/bin/bash -eux

apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends docker.io
systemctl enable --now docker
usermod -aG docker vagrant

docker pull python:3.7
