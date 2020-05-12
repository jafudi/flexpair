#!/usr/bin/env bash

# when guacamole works add -localhost flag to x1vnc again for more security

cd /var/tmp/traction/guacamole
./reset.sh
./prepare.sh
docker-compose up -d
