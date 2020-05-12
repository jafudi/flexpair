#!/usr/bin/env bash

# when guacamole works add -localhost flag to x1vnc again for more security

git clone "https://github.com/boschkundendienst/guacamole-docker-compose.git"
cd guacamole-docker-compose
./prepare.sh
docker-compose up -d
