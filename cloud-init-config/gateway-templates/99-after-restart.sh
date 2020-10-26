#!/usr/bin/env bash

if [ ! -f /etc/.terraform-complete ]; then
    echo "Terraform provisioning not yet complete, exiting"
    exit 0
fi

systemctl enable --now docker
usermod -aG docker ubuntu

cd ${DOCKER_COMPOSE_FOLDER}

curl  --silent -L "${DOCKER_COMPOSE_REPO}/docker-compose-$(uname -s)-$(uname -m)" \
      -o /usr/local/bin/docker-compose ] && chmod +x /usr/local/bin/docker-compose

mkdir ./init >/dev/null 2>&1
docker run --rm guacamole/guacamole /opt/guacamole/bin/initdb.sh --postgres > ./init/initdb.sql
chmod -R +x ./init
passwd -d ubuntu # for direct SSH access from guacd_container

docker-compose up

cloud-init collect-logs
tar -xzf cloud-init.tar.gz
rm -f cloud-init.tar.gz
cd cloud-init-logs*
cat cloud-init-output.log
