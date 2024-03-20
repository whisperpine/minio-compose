#!/bin/sh

self_sign_tls() {
    if [ -e $1 ]; then
        echo ":: $1 exists."
    else
        echo ":: $1 does not exist."
        echo ":: now creating dummy certificates to avoid Nginx startup failure."

        mkdir -p $1 && cd $1
        openssl genrsa -out privkey.pem 2048
        openssl req -new -key privkey.pem -out csr.pem -subj "/O=dummy"
        openssl x509 -req -days 365 -in csr.pem -signkey privkey.pem -out fullchain.pem
    fi
}

self_sign_tls "/etc/nginx/ssl/live/$MINIO_API_DOMAIN"
self_sign_tls "/etc/nginx/ssl/live/$MINIO_CONSOLE_DOMAIN"
