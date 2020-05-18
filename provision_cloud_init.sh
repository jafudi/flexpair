#!/usr/bin/env bash

DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install --upgrade -y --no-install-recommends cloud-init

cp /var/tmp/traction/grub.cfg /etc/default/grub
update-grub


