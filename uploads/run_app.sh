#!/usr/bin/env bash

# hard linked

if [ $# -lt 3 ]
then
    echo "Interactive mode"
    DOCKER_IMAGE="jafudi/idea-extractor:latest"
    INPUT_FOLDER=$(kdialog --getexistingdirectory --title "Bitte Ordner mit Dokumenten auswählen")
    OUTPUT_BASE=$(kdialog --getexistingdirectory --title "Bitte Ordner für Ausgabe auswählen")
else
    echo "Unattended mode"
    DOCKER_IMAGE=$1
    INPUT_FOLDER=$2
    OUTPUT_BASE=$3
fi

docker pull "${DOCKER_IMAGE}"

INTERNAL_NETWORK=strictly_internal
docker network inspect $INTERNAL_NETWORK >/dev/null 2>&1\
    || docker network create --internal $INTERNAL_NETWORK

docker info

# sudo docker stack deploy --compose-file docker-stack.yaml test

docker run\
    --network=strictly_internal\
    --mount "type=bind,source=${INPUT_FOLDER},target=/input"\
    --mount "type=bind,source=${OUTPUT_BASE},target=/output"\
    "${DOCKER_IMAGE}"

sudo chmod 777 -R "${OUTPUT_BASE}"
