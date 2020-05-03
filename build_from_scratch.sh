#!/usr/bin/env bash

vagrant destroy --force
# https://packer.io/docs/builders/virtualbox-iso.html
packer build -force -only=virtualbox-iso packer-desktop/ubuntu/pack-lubuntu.json
vagrant box remove --all Jafudi/ludopy
vagrant box add --clean --force Jafudi/ludopy packer-desktop/builds/lubuntu-docker-python.virtualbox.box
vagrant up
gitlab-runner unregister --all-runners
rm -f ~/.gitlab-runner/config.toml
launchctl setenv PATH $PATH
gitlab-runner register \
    --non-interactive \
    --url="https://gitlab.com/" \
    --registration-token="JW6YYWLG4mTsr_-mSaz8" \
    --executor="virtualbox" \
    --description="ludopy-on-virtualbox" \
    --tag-list="virtualbox,ubuntu" \
    --virtualbox-base-name="lubuntu-docker-python" \
    --virtualbox-disable-snapshots="false" \
    --ssh-user="vagrant" \
    --ssh-password="vagrant" \
    --ssh-identity-file="$PWD/.vagrant/machines/default/virtualbox/private_key"
gitlab-runner restart
gitlab-runner status