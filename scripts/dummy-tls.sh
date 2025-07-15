#!/bin/sh

# This file should be mounted to nginx container under `/docker-entrypoint.d`.
# This is for creating dummy tls certs to avoid nginx crash loop.

self_sign_tls() {
    TARGET_PATH="/etc/nginx/ssl/live/$1"
    if [ -e "$TARGET_PATH" ]; then
        echo ":: $TARGET_PATH exists."
    else
        echo ":: $TARGET_PATH does not exist."
        echo ":: now creating dummy certificates to avoid Nginx startup failure."

        mkdir -p "$TARGET_PATH"
        cd "$TARGET_PATH" || exit 1

        openssl genrsa -out privkey.pem 2048
        openssl req -new -key privkey.pem -out csr.pem -subj "/O=dummy"
        openssl x509 -req -days 365 -in csr.pem -signkey privkey.pem -out fullchain.pem
        chmod 644 ./*
    fi
}

self_sign_tls "$MINIO_API_DOMAIN"
self_sign_tls "$MINIO_CONSOLE_DOMAIN"
