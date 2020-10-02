Content-Type: multipart/mixed; boundary="====Part=Boundary================================================="
MIME-Version: 1.0

--====Part=Boundary=================================================
Content-Type: text/cloud-config; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="cloud-config.yaml"

#cloud-config

bootcmd:
  - mkdir -p /home/ubuntu/uploads
  - chown -R ubuntu /home/ubuntu

users:
    - default

# Set the system timezone
timezone: Europe/Berlin

locale: de_DE.UTF-8

--====Part=Boundary=================================================
Content-Type: text/x-shellscript; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="guacamole-user-script.sh"

#!/usr/bin/env bash

if [ ! -f /etc/.terraform-complete ]; then
    echo "Terraform provisioning not yet complete, exiting"
    exit 0
fi

echo "Bootstrapping using cloud-init..."

# Is there an alternative to removing the user password ? ###########

sudo passwd -d ubuntu # for direct SSH access from guacd_container
chown -R ubuntu /home/ubuntu # handing over home folder to user

# Start mail server ################################################

docker-compose up -d imap

# Provision communication stack ####################################

cd ${GUACAMOLE_HOME}

echo "Preparing folder init and creating ./init/initdb.sql"
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

mkdir -p ${CERTBOT_FOLDER}

if [ ! -e "${CERTBOT_FOLDER}/conf/options-ssl-nginx.conf" ] || [ ! -e "${CERTBOT_FOLDER}/conf/ssl-dhparams.pem" ]; then
  echo "### Downloading recommended TLS parameters ..."
  mkdir -p "${CERTBOT_FOLDER}/conf"
  curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot-nginx/certbot_nginx/_internal/tls_configs/options-ssl-nginx.conf | sudo tee "${CERTBOT_FOLDER}/conf/options-ssl-nginx.conf" > /dev/null
  curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot/certbot/ssl-dhparams.pem | sudo tee "${CERTBOT_FOLDER}/conf/ssl-dhparams.pem" > /dev/null
  echo
fi

echo "### Creating dummy certificate for ${SSL_DOMAIN} ..."
sudo mkdir -p "${CERTBOT_FOLDER}/conf/live"
sudo chmod 777 "${CERTBOT_FOLDER}/conf/live"
docker-compose run --rm --entrypoint "\
  openssl req -x509 -nodes -newkey 'rsa:4096' -days 90\
    -keyout '/etc/letsencrypt/live/privkey.pem' \
    -out '/etc/letsencrypt/live/fullchain.pem' \
    -subj '/CN=localhost'" certbot

echo "### Starting nginx ..."
docker-compose up --force-recreate -d nginx
echo

echo "### Saving away dummy certificate for ${SSL_DOMAIN} ..."
sudo mkdir -p ${CERTBOT_FOLDER}/conf/archive/dummy
sudo mv ${CERTBOT_FOLDER}/conf/live/* ${CERTBOT_FOLDER}/conf/archive/dummy/
sudo rm -Rf ${CERTBOT_FOLDER}/conf/renewal/${SSL_DOMAIN}.conf

echo "### Requesting Let's Encrypt certificate for ${SSL_DOMAIN} ..."
# https://letsencrypt.org/docs/rate-limits/
# 50 certificates per registered domain per week i.e. theworkpc.com
# including other people's certificates!
# + 5 renewals per subdomain per week

# Enable staging mode if needed
if [ ${STAGING_MODE} != "0" ]; then staging_arg="--staging"; fi

mkdir -p "${CERTBOT_FOLDER}/logs"

docker-compose run --rm --entrypoint "\
  certbot certonly --webroot --webroot-path /var/www/certbot \
    $staging_arg \
    --email ${EMAIL_ADDRESS} \
    -d ${SSL_DOMAIN} \
    --rsa-key-size 4096 \
    --agree-tos \
    --non-interactive \
    --force-renewal" \
    certbot

exitcode=$?

if [ $exitcode -eq 0 ]; then
  if [ -d "${CERTBOT_FOLDER}/conf/live/${SSL_DOMAIN}-0001" ]; then
    echo "Deduplicating certificate. Look here https://community.letsencrypt.org/t/certbot-renew-request-saves-certificates-to-0001-to-folder/49654/9"
    mv "${CERTBOT_FOLDER}/conf/live/${SSL_DOMAIN}-0001" "${CERTBOT_FOLDER}/conf/live/${SSL_DOMAIN}"
  fi
  sudo cp -L ${CERTBOT_FOLDER}/conf/live/${SSL_DOMAIN}/* ${CERTBOT_FOLDER}/conf/live/

  echo "### Loading nginx and murmur with new certificate..."
  sudo rm -rf ${GUACAMOLE_HOME}/murmur_cert
  sudo mkdir -p ${GUACAMOLE_HOME}/murmur_cert
  sudo cp -L ${CERTBOT_FOLDER}/conf/live/${SSL_DOMAIN}/* ${GUACAMOLE_HOME}/murmur_cert/
  docker-compose up --force-recreate -d nginx
else
    # https://github.com/letsdebug/letsdebug#problems-detected
    apt-get install --upgrade -y --no-install-recommends jq
    while true; do
        reqid=$(curl --silent --data "{\"method\":\"http-01\",\"domain\":\"${SSL_DOMAIN}\"}" -H 'content-type: application/json' https://letsdebug.net | jq -r '.ID')
        sleep 30s
        results=$(curl --silent -H 'accept: application/json' "https://letsdebug.net/${SSL_DOMAIN}/$reqid?debug=y" |sed 's/\\./ /g' | jq -r '.result')
        severity=$(echo "$results" | jq -r '.problems[0].severity')
        case "$severity" in
        Fatal)
            echo "$results" | jq -r '.problems[0]'
            ;;
        Error|Warning|Debug)
            break
            ;;
        *)
            echo "Unknown severity level."
            exit 1
            ;;
        esac
    done
    echo "$results" | jq -r '.problems'
fi

cloud-init collect-logs
tar -xzf cloud-init.tar.gz
rm -f cloud-init.tar.gz
cd cloud-init-logs*
cat /var/log/cloud-init-output.log

--====Part=Boundary=================================================--
