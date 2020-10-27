#!/usr/bin/env bash

mkdir -p  "${GUACAMOLE_CONFIG}"

cat << EOF > "${GUACAMOLE_CONFIG}/docker-compose.yml"
# The initial login to the guacamole webinterface is:
#
#     Username: guacadmin
#     Password: guacadmin

version: '3'

networks:
  guacamole_net:
    driver: bridge
    driver_opts:
      com.docker.network.bridge.name: guac_bridge
    ipam:
      driver: default
      config:
        - subnet: 172.18.0.0/24
        # gateway is then 172.18.0.1 by convention


services:
  guacd:
    container_name: guacd_container
    image: guacamole/guacd
    networks:
      guacamole_net:
        ipv4_address: 172.18.0.2
    restart: always
    volumes:
      - ./drive:/drive:rw
      - ./record:/record:rw
    extra_hosts:
      - "gateway:172.18.0.1" # Enable connection to gateway host

  postgres:
    container_name: postgres_container
    environment:
      PGDATA: /var/lib/postgresql/data/guacamole
      POSTGRES_DB: guacamole_db
      POSTGRES_PASSWORD: sdfalksjhdlkfjhasdf676876234fds78723ghsdfk
      POSTGRES_USER: guacamole_user
    image: postgres
    networks:
      guacamole_net:
        ipv4_address: 172.18.0.3
    restart: always
    volumes:
      - ./init:/docker-entrypoint-initdb.d:ro
      - ./data:/var/lib/postgresql/data:rw

#  Make sure you use the same value for 'POSTGRES_USER' and 'POSTGRES_PASSWORD'
#  as configured above
  guacamole:
    container_name: guacamole_container
    depends_on:
      - guacd
      - postgres
    environment:
      GUACD_HOSTNAME: guacd
      POSTGRES_DATABASE: guacamole_db
      POSTGRES_HOSTNAME: postgres
      POSTGRES_PASSWORD: sdfalksjhdlkfjhasdf676876234fds78723ghsdfk
      POSTGRES_USER: guacamole_user
      GUACAMOLE_HOME: /var/tmp/config_dir
    volumes:
      - ./guaca_config:/var/tmp/config_dir
    image: guacamole/guacamole
    networks:
      guacamole_net:
        ipv4_address: 172.18.0.4
    ports:
      - "8080/tcp"
    restart: always

  murmur:
    image: goofball222/murmur
    networks:
      guacamole_net:
        ipv4_address: 172.18.0.5
    container_name: murmur
    ports:
      - "${MURMUR_PORT}:${MURMUR_PORT}"
      - "${MURMUR_PORT}:${MURMUR_PORT}/udp"
    volumes:
      - ./murmur_config:/opt/murmur/config
      - ./murmur_data:/opt/murmur/data
      - ./murmur_log:/opt/murmur/log
      - ./letsencrypt:/opt/murmur/cert
    environment:
      - TZ=UTC

  mumble:
    image: jafudi/mumble-web-lite:latest
    networks:
      guacamole_net:
        ipv4_address: 172.18.0.6
    container_name: mumble_web_container
    ports:
      - "8081:8081"
    depends_on:
      - murmur
    environment:
      - MUMBLE_SERVER=murmur:${MURMUR_PORT}

#  To debug nginx replace '&& nginx -g 'daemon off' with '&& nginx-debug -g 'daemon off'
  nginx:
    container_name: nginx_container
    restart: always
    image: nginx
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf:ro
      - ./nginx/conf.d/default.conf:/etc/nginx/conf.d/default.conf:ro
      - ./nginx/conf.d/options-ssl-nginx.conf:/etc/nginx/conf.d/options-ssl-nginx.conf:ro
      - ./letsencrypt:/etc/letsencrypt:ro
    ports:
      - "443:443"
      - "80:80"
    depends_on:
      - guacamole
      - mumble
    networks:
      guacamole_net:
        ipv4_address: 172.18.0.7
    extra_hosts:
      - "gateway:172.18.0.1" # Enable connection to gateway host
    command: /bin/bash -c "nginx -g 'daemon off;'"
    # command: "/bin/sh -c 'while :; do sleep 6h & wait $${!}; nginx -s reload; done & nginx -g \"daemon off;\"'"

  imap:
    image: jafudi/docker-imap-devel
    container_name: imap_container
    networks:
      guacamole_net:
        ipv4_address: 172.18.0.9
    ports:
    - "25:25"
    - "143:143"
    environment:
    - MAILNAME=${SSL_DOMAIN}
    - MAIL_ADDRESS=${EMAIL_ADDRESS}
    - MAIL_PASS=${IMAP_PASSWORD}
EOF
