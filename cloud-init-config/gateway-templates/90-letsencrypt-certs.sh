#!/usr/bin/env bash

mkdir -p  "${CERT_FOLDER}"

cat <<EOF > "${CERT_FOLDER}/privkey.pem"
${PRIVATE_KEY}
EOF

cat <<EOF > "${CERT_FOLDER}/fullchain.pem"
${FULL_CHAIN}
EOF




