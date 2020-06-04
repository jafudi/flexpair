#!/usr/bin/env bash

domain=`get_info metadata/ssl-sub-domain`
rsa_key_size=4096
data_path="./letsencrypt/certbot"
mkdir -p ${data_path}
email="socialnets@jafudi.com" # Adding a valid address is strongly recommended
staging=0 # Set to 1 if you're testing your setup to avoid hitting request limits
export ETH0_IP=$(ip addr show eth0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)

if [ ! -e "$data_path/conf/options-ssl-nginx.conf" ] || [ ! -e "$data_path/conf/ssl-dhparams.pem" ]; then
  echo "### Downloading recommended TLS parameters ..."
  mkdir -p "$data_path/conf"
  curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot-nginx/certbot_nginx/_internal/tls_configs/options-ssl-nginx.conf > "$data_path/conf/options-ssl-nginx.conf"
  curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot/certbot/ssl-dhparams.pem > "$data_path/conf/ssl-dhparams.pem"
  echo
fi

echo "### Creating dummy certificate for $domain ..."
container_path="/etc/letsencrypt"
host_path="$data_path/conf"
sudo mkdir -p "${host_path}/live/$domain"
sudo chmod 777 "${host_path}/live/$domain"
docker-compose run --rm --entrypoint "\
  openssl req -x509 -nodes -newkey rsa:1024 -days 1\
    -keyout '${container_path}/live/${domain}/privkey.pem' \
    -out '${container_path}/live/${domain}/fullchain.pem' \
    -subj '/CN=localhost'" certbot

echo "### Starting nginx ..."
docker-compose up --force-recreate -d nginx
echo

echo "### Archiving dummy certificate for $domain ..."
sudo rm -Rf ${host_path}/archive/$domain/
sudo mkdir -p ${host_path}/archive/
sudo mv "${host_path}/live/$domain" "${host_path}/archive/"
sudo rm -Rf ${host_path}/renewal/$domain.conf

echo "### Requesting Let's Encrypt certificate for $domain ..."
domain_args="-d $domain"

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
    $domain_args \
    --rsa-key-size $rsa_key_size \
    --agree-tos \
    --non-interactive \
    --force-renewal" \
    certbot

exitcode=$?
echo "Certbot returned value '$exitcode'."

if [ $exitcode -eq 0 ]; then
    echo "### Reloading nginx with new certificate..."
    docker-compose exec nginx nginx -s reload
else
    echo "### Restoring dummy certificate for $domain ..."
    sudo rm -Rf "${host_path}/live/$domain"
    sudo mv "${host_path}/archive/$domain" "${host_path}/live/"
    sudo rm -Rf "${host_path}/renewal/$domain.conf"
fi
