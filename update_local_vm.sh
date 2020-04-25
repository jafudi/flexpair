#!/usr/bin/env bash

vagrant destroy
vagrant up
gitlab-runner start
gitlab-runner unregister --all-runners
rm -f ~/.gitlab-runner/config.toml
launchctl setenv PATH $PATH
gitlab-runner register \
    --non-interactive \
    --url="https://gitlab.com/" \
    --registration-token="JW6YYWLG4mTsr_-mSaz8" \
    --executor="virtualbox" \
    --description="lubuntu-docker-python" \
    --tag-list="virtualbox" \
    --virtualbox-base-name="lubuntu-docker-python" \
    --virtualbox-disable-snapshots="false" \
    --ssh-user="vagrant" \
    --ssh-password="vagrant" \
    --ssh-identity-file="$PWD/.vagrant/machines/default/virtualbox/private_key"
gitlab-runner restart
gitlab-runner status
