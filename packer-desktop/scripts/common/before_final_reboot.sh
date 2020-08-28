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

# https://github.com/letsdebug/letsdebug#problems-detected
apt-get install --upgrade -y --no-install-recommends jq
while true; do
    curl --silent --data "{\"method\":\"http-01\",\"domain\":\"${DYNU_DOMAIN}\"}" -H 'content-type: application/json' https://letsdebug.net
    sleep 30s
    results=$(curl --silent -H 'accept: application/json' https://letsdebug.net/${DYNU_DOMAIN} |sed 's/\\n/ /g' |sed 's/\\t/ /g' | jq -r '.[0].result')
    severity=$(echo "${results}" | jq -r '.problems[0].severity')
    case "$severity" in
    Fatal)
        echo "${results}" | jq -r '.problems[0]'
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
echo "${results}" | jq -r '.problems'
echo "Let's Encrypt should succeed assuming nginx starts up correctly."
echo "Initiating final reboot now..."



