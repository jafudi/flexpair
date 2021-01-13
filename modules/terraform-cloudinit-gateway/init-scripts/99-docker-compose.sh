#!/bin/bash -eux

systemctl enable --now docker
usermod -aG docker "${GATEWAY_USERNAME}"

mkdir -p "${DOCKER_COMPOSE_FOLDER}"
cd "${DOCKER_COMPOSE_FOLDER}"

curl  --silent -L "${DOCKER_COMPOSE_REPO}/docker-compose-$(uname -s)-$(uname -m)" \
      -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose

mkdir ./init >/dev/null 2>&1
docker run --rm guacamole/guacamole /opt/guacamole/bin/initdb.sh --postgres > ./init/initdb.sql
chmod -R +x ./init
passwd -d "${GATEWAY_USERNAME}" # for direct SSH access from guacd_container

cloud-init collect-logs
tar -xzf cloud-init.tar.gz
rm -f cloud-init.tar.gz

cat << 'EOF' > "${DOCKER_COMPOSE_FOLDER}/docker-compose.yml"
${DOCKER_COMPOSE_YAML}
EOF

cat << 'EOF' > /etc/systemd/system/docker-compose.service
[Unit]
Description=Docker Compose as a Service
Requires=docker.service
After=docker.service

[Service]
Type=simple
WorkingDirectory=${DOCKER_COMPOSE_FOLDER}
ExecStart=/usr/local/bin/docker-compose up
ExecStop=/usr/local/bin/docker-compose down

[Install]
WantedBy=default.target
EOF
systemctl enable docker-compose.service
systemctl start docker-compose.service

wget --directory-prefix="/home/${GATEWAY_USERNAME}/uploads/Government Documents (Public)" "http://downloads.digitalcorpora.org/corpora/files/govdocs1/threads/thread7.zip"
