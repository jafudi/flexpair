#!/usr/bin/env bash

if [ ! -f /etc/.terraform-complete ]; then
    echo "Terraform provisioning not yet complete, exiting"
    exit 0
fi

echo "Bootstrapping using cloud-init..."

# Is there an alternative to removing the user password ? ###########

passwd -d ubuntu # for direct SSH access from guacd_container

# Provision Docker Compose ####################################

echo "Installing Docker and Docker Compose..."

systemctl enable --now docker
usermod -aG docker ubuntu

curl --silent \
  -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_RELEASE}/docker-compose-$(uname -s)-$(uname -m)" \
  -o /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose

cd ${DOCKER_COMPOSE_FOLDER}

echo "Preparing folder init and creating ./init/initdb.sql..."
mkdir ./init >/dev/null 2>&1
mkdir -p ./nginx/ssl >/dev/null 2>&1
rm -rf ./data
docker run --rm guacamole/guacamole /opt/guacamole/bin/initdb.sh --postgres > ./init/initdb.sql
if [[ -s ./init/initdb.sql ]]; then
    sudo chmod -R +x ./init
    echo "done"
else
    echo "./init/initdb.sql was rendered empty. Exit."
    exit 1
fi

echo "Bringing up Docker Compose..."
echo
docker-compose up

cloud-init collect-logs
tar -xzf cloud-init.tar.gz
rm -f cloud-init.tar.gz
cd cloud-init-logs*
cat cloud-init-output.log