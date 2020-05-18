#!/usr/bin/env bash

# when guacamole works add -localhost flag to x1vnc again for more security

export GUACAMOLE_HOME=/var/tmp/traction/guacamole
cd ${GUACAMOLE_HOME}
./prepare.sh
export ETH0_IP=$(ip addr show eth0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)
docker-compose up -d
