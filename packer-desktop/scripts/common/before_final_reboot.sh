#!/usr/bin/env bash

# https://cloudinit.readthedocs.io/en/latest/
# https://help.ubuntu.com/community/CloudInit

REQUIRED_PKG="cloud-init"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
echo Checking for $REQUIRED_PKG: $PKG_OK
if [ "" = "$PKG_OK" ]; then
    echo "Install cloud-init..."
    # Prepare for cloud-init to run at next boot
    DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get install --upgrade -y --no-install-recommends cloud-init
fi

cloud-init clean --logs

# Wait for Google DNS to return non-trivial IP address
apt-get install --upgrade -y --no-install-recommends jq
propagation_status=1
echo "Waiting for DNS records to propagate to Google Public DNS..."
until [ ${propagation_status} -eq 0 ]; do
    sleep 3s
    google_dns_records=$(curl --silent -X POST "https://dns.google.com/resolve?name=${DYNU_DOMAIN}&type=A")
    answer_status=$(echo ${google_dns_records} | jq '.Status')
    if [ ${answer_status} -eq 0 ]; then
        echo ${google_dns_records} | jq '.Answer[]'
        answer_data=$(echo ${google_dns_records} \
            | jq --arg reqdomain "${DYNU_DOMAIN}." '.Answer[] | select(.name==$reqdomain) | .data')
        if [ "${answer_data}" != "1.2.3.4" ]; then
            propagation_status=0
        else
            echo "Only initial default record found."
        fi
    else
        echo "No records exist yet."
    fi
done
echo "Success."
echo "Initiating final reboot now..."



