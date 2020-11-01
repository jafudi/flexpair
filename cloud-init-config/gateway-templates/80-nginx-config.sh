#!/usr/bin/env bash

mkdir -p  "${NGINX_CONFIG}/conf.d"

cat << 'EOF' > "${NGINX_CONFIG}/nginx.conf"
### AAA
user  nginx;
worker_processes  1;

error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;


events {
    worker_connections  1024;
}


http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile        on;

    ## Hide Nginx version ##
    server_tokens   off;

    ## Security headers for Nginx ##
    add_header X-Content-Type-Options "nosniff" always;
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
    add_header Content-Security-Policy "frame-ancestors 'self'" always;

    keepalive_timeout  65;

    gzip  on;
    gzip_types
        text/plain
        text/javascript
        application/javascript
        application/x-javascript;

    include /etc/nginx/conf.d/default.conf;
}
EOF

cat << 'EOF' > "${NGINX_CONFIG}/conf.d/default.conf"
server {
    listen 80;
    server_name  _;
    server_tokens off;

    location / {
        return 301 https://$host$request_uri;
    }
}

server {
    listen 443 ssl http2;
    server_name  _;

    ssl_certificate /etc/letsencrypt/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/privkey.pem;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

    include /etc/nginx/conf.d/options-ssl-nginx.conf;

    location / {
        proxy_pass http://mumble:8081/;
    }

    location /murmur {
        proxy_pass http://mumble:8081;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade;
    }

    location /guacamole/ {
        proxy_pass http://guacamole:8080/guacamole/;
        proxy_buffering off;
        proxy_http_version 1.1;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $http_connection;
        access_log off;
        client_max_body_size 4096m;
    }

    location /desktop-traffic/ {
        proxy_set_header X-Real-IP  $remote_addr;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header Host $host;
        proxy_pass http://gateway:6667/;
        rewrite /desktop-traffic/(.*) /$1 break;
    }

    error_page 500 502 503 504  /50x.html;

    location = /50x.html {
        root /usr/share/nginx/html;
    }

}

map $http_upgrade $connection_upgrade {
        default upgrade;
        '' close;
}
EOF

# This file contains important security parameters for NGINX.
curl -s "${CERTBOT_REPO}/certbot-nginx/certbot_nginx/_internal/tls_configs/options-ssl-nginx.conf" | tee "${NGINX_CONFIG}/conf.d/options-ssl-nginx.conf" > /dev/null
