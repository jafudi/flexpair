#!/usr/bin/env bash

DESCRIPTION="Shell executor on $(uname -s)"

HOST_TAGS="$( \
    hostnamectl \
    | sed -E -e 's/^[ ]*//;s/[^a-zA-Z0-9\.]+/-/g;s/(.*)/\L\1/;' \
    | tr '\n' ',' \
)"

ROUTE_TAGS="$( \
    traceroute --max-hops=3 8.8.8.8 \
    | sed -E -e '1d;s/^[ ]+[0-9][ ]+([a-zA-Z]+?).*/\1/;/^$/d;s/^/gateway-/' \
    | tr '\n' ',' \
)"

sudo gitlab-runner register \
--non-interactive \
--url="https://gitlab.com/" \
--registration-token="JW6YYWLG4mTsr_-mSaz8" \
--executor="shell" \
--description="${DESCRIPTION}" \
--tag-list="${HOST_TAGS},${ROUTE_TAGS}"

sudo gitlab-runner restart
sudo gitlab-runner status
