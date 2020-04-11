#!/usr/bin/env bash

DOCKER_IMAGE=$1
INPUT_FOLDER=$2
OUTPUT_BASE=$3


sudo docker pull ${DOCKER_IMAGE}

INTERNAL_NETWORK=strictly_internal
docker network inspect $INTERNAL_NETWORK >/dev/null 2>&1\
    || sudo docker network create --internal $INTERNAL_NETWORK
sudo docker info

sudo docker run\
    --network=strictly_internal\
    --mount type=bind,source=${INPUT_FOLDER},target=/input\
    --mount type=bind,source=${OUTPUT_BASE},target=/output\
    ${DOCKER_IMAGE}
