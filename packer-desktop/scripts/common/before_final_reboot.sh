#!/usr/bin/env bash

cloud-init clean --logs

# https://github.com/letsdebug/letsdebug#problems-detected
apt-get install --upgrade -y --no-install-recommends jq
while true; do
    req_id=$(curl --silent --data "{\"method\":\"http-01\",\"domain\":\"${FULLY_QUALIFIED_DOMAIN}\"}" -H 'content-type: application/json' https://letsdebug.net | jq -r '.ID')
    sleep 30s
    results=$(curl --silent -H 'accept: application/json' "https://letsdebug.net/${FULLY_QUALIFIED_DOMAIN}/${req_id}?debug=y" |sed 's/\\./ /g' | jq -r '.result')
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


sudo touch /etc/.terraform-complete
echo "Initiating final reboot now..."



