#!/usr/bin/env bash

function random_free_registered_domain() {
    array[0]="ddnsfree.com"
    array[1]="ddnsgeek.com"
    array[2]="giize.com"
    array[3]="gleeze.com"
    array[4]="kozow.com"
    array[5]="loseyourip.com"
    array[6]="ooguy.com"
    array[7]="theworkpc.com"
    array[8]="freeddns.org"
    array[9]="mywire.org"
    array[10]="webredirect.org"

    size=${#array[@]}
    index=$(($RANDOM % $size))
    local choice=${array[$index]}
    echo "$choice"
}

function create_ddns_record() {
    echo "Creating dynamic DNS record for domain $1..."
    DYNU_API_URL="https://api.dynu.com/v2"
    DYNU_API_KEY="56ge3636efbe35323352VX6d6c4dY4f5"
    return_status=$(curl --silent -X POST "${DYNU_API_URL}/dns" \
         -H "accept: application/json" \
         -H "API-Key: ${DYNU_API_KEY}" \
         -H "Content-Type: application/json" \
         -d "{\"name\":\"$1\",\"ipv4Address\":\"1.2.3.4\",\"ttl\":300,\"ipv4\":true,\"ipv6\":false,\"ipv4WildcardAlias\":true,\"ipv6WildcardAlias\":false,\"allowZoneTransfer\":false,\"dnssec\":false}")
    assert_eq "{\"statusCode\":200}" "${return_status}" "Could not create DNS record." || exit 1
}

function wait_for_dns_propagation() {
    dns_propagated=1
    until [ ${dns_propagated} ]; do
        echo "Waiting for DNS records to propagate Google Public DNS..."
        sleep 3s
        google_dns_records=$(curl --silent -X POST "https://dns.google.com/resolve?name=$1&type=A")
        dns_propagated=$(echo ${google_dns_records} | jq -r '.Status')
    done
    echo "Success in checking that subdomain is publicly listed."
}