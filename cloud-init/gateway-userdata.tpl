Content-Type: multipart/mixed; boundary="====Part=Boundary================================================="
MIME-Version: 1.0

--====Part=Boundary=================================================
Content-Type: text/cloud-config; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="cloud-config.yaml"

#cloud-config

bootcmd:
  - mkdir -p /home/ubuntu/uploads
  - chown ubuntu -R /home/ubuntu

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
chown ubuntu -R /home/ubuntu # handing over home folder to user

# Start mail server ################################################

docker-compose up -d imap

# Provision communication stack ####################################

domain=${SSL_DOMAIN}
export GUACAMOLE_HOME=/var/tmp/guacamole
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


rsa_key_size=4096
data_path="./letsencrypt/certbot"
mkdir -p ${data_path}
email="${EMAIL_ADDRESS}" # Adding a valid address is strongly recommended
staging=0 # Set to 1 if you're testing your setup to avoid hitting request limits

if [ ! -e "$data_path/conf/options-ssl-nginx.conf" ] || [ ! -e "$data_path/conf/ssl-dhparams.pem" ]; then
  echo "### Downloading recommended TLS parameters ..."
  mkdir -p "$data_path/conf"
  curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot-nginx/certbot_nginx/_internal/tls_configs/options-ssl-nginx.conf | sudo tee "$data_path/conf/options-ssl-nginx.conf" > /dev/null
  curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot/certbot/ssl-dhparams.pem | sudo tee "$data_path/conf/ssl-dhparams.pem" > /dev/null
  echo
fi

echo "### Creating dummy certificate for $domain ..."
container_path="/etc/letsencrypt"
host_path="$data_path/conf"
sudo mkdir -p "${host_path}/live"
sudo chmod 777 "${host_path}/live"
docker-compose run --rm --entrypoint "\
  openssl req -x509 -nodes -newkey 'rsa:${rsa_key_size}' -days 90\
    -keyout '${container_path}/live/privkey.pem' \
    -out '${container_path}/live/fullchain.pem' \
    -subj '/CN=localhost'" certbot

echo "### Starting nginx ..."
docker-compose up --force-recreate -d nginx
echo

echo "### Saving away dummy certificate for $domain ..."
sudo mkdir -p ${host_path}/archive/dummy
sudo mv ${host_path}/live/* ${host_path}/archive/dummy/
sudo rm -Rf ${host_path}/renewal/$domain.conf

echo "### Requesting Let's Encrypt certificate for $domain ..."
# https://letsencrypt.org/docs/rate-limits/
# 50 certificates per registered domain per week i.e. theworkpc.com
# including other people's certificates!
# + 5 renewals per subdomain per week

# Select appropriate email arg
case "$email" in
  "") email_arg="--register-unsafely-without-email" ;;
  *) email_arg="--email $email" ;;
esac

# Enable staging mode if needed
if [ $staging != "0" ]; then staging_arg="--staging"; fi

mkdir -p "$data_path/logs"

docker-compose run --rm --entrypoint "\
  certbot certonly --webroot --webroot-path /var/www/certbot \
    $staging_arg \
    $email_arg \
    -d $domain \
    --rsa-key-size $rsa_key_size \
    --agree-tos \
    --non-interactive \
    --force-renewal" \
    certbot

exitcode=$?

if [ $exitcode -eq 0 ]; then
  if [ -d "${host_path}/live/$domain-0001" ]; then
    echo "Deduplicating certificate. Look here https://community.letsencrypt.org/t/certbot-renew-request-saves-certificates-to-0001-to-folder/49654/9"
    mv "${host_path}/live/$domain-0001" "${host_path}/live/$domain"
  fi
  sudo cp -L ${host_path}/live/$domain/* ${host_path}/live/

  echo "### Loading nginx and murmur with new certificate..."
  sudo rm -rf ${GUACAMOLE_HOME}/murmur_cert
  sudo mkdir -p ${GUACAMOLE_HOME}/murmur_cert
  sudo cp -L ${host_path}/live/$domain/* ${GUACAMOLE_HOME}/murmur_cert/
  docker-compose up --force-recreate -d nginx
else
  echo "Certbot returned error code '$exitcode'."
  exit 1
fi

--====Part=Boundary=================================================--
