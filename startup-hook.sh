#!/bin/sh

self_sign_tls() {
    mkdir -p $1
    cd $1

    FULLCHAIN_PATH="$1/fullchain.pem"
    PRIVKEY_PATH="$1/privkey.pem"

    if [ -d $FULLCHAIN_PATH ] && [ -d $PRIVKEY_PATH ]; then
        echo ":: tls files exist."
    else
        echo ":: $FULLCHAIN_PATH does not exist, or"
        echo ":: $PRIVKEY_PATH does not exist."
        echo ":: now creating dummy certificates to avoid Nginx startup failure."

        openssl genrsa -out privkey.pem 2048
        openssl req -new -key privkey.pem -out csr.pem -subj "/O=dummy"
        openssl x509 -req -days 365 -in csr.pem -signkey privkey.pem -out fullchain.pem
        echo "pwd: $(pwd)"
    fi
}

self_sign_tls "/etc/nginx/ssl/live/$MINIO_API_DOMAIN"
self_sign_tls "/etc/nginx/ssl/live/$MINIO_CONSOLE_DOMAIN"
