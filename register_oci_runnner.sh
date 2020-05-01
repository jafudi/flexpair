#!/usr/bin/env bash

sudo gitlab-runner unregister --all-runners
sudo rm -f /var/lib/gitlab-runner/config.toml
sudo gitlab-runner register \
    --non-interactive \
    --url="https://gitlab.com/" \
    --registration-token="JW6YYWLG4mTsr_-mSaz8" \
    --executor="shell" \
    --description="ludopy-local-shell" \
    --tag-list="localhost,bash"
sudo gitlab-runner restart
sudo gitlab-runner status
