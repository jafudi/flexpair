#!/usr/bin/env bash

mkdir -p  "${CERT_FOLDER}"

cat <<EOF > "${CERT_FOLDER}/privkey.pem"
${PRIVATE_KEY}
EOF

cat <<EOF > "${CERT_FOLDER}/fullchain.pem"
${CERTIFICATE}
${ISSUER_CHAIN}
EOF

# Diffie-Hellman parameters required for https://en.wikipedia.org/wiki/Forward_secrecy
curl -s "${CERTBOT_REPO}/certbot/certbot/ssl-dhparams.pem" | tee ssl-dhparams.pem > /dev/null
