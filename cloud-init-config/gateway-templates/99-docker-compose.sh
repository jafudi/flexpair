#!/usr/bin/env bash

systemctl enable --now docker
usermod -aG docker ubuntu

mkdir -p "${DOCKER_COMPOSE_FOLDER}"
cd ${DOCKER_COMPOSE_FOLDER}

curl  --silent -L "${DOCKER_COMPOSE_REPO}/docker-compose-$(uname -s)-$(uname -m)" \
      -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose

mkdir ./init >/dev/null 2>&1
docker run --rm guacamole/guacamole /opt/guacamole/bin/initdb.sh --postgres > ./init/initdb.sql
chmod -R +x ./init
passwd -d ubuntu # for direct SSH access from guacd_container

cloud-init collect-logs
tar -xzf cloud-init.tar.gz
rm -f cloud-init.tar.gz

cat << EOF > "${DOCKER_COMPOSE_FOLDER}/docker-compose.yml"
${DOCKER_COMPOSE_YAML}
EOF

docker-compose up
