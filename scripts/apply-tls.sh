#!/bin/sh

# Run this script to apply free tls certs.

set -e

# ------------------------------
# get env vars
# ------------------------------

# shellcheck disable=SC1091
. ./.env

# echo $MINIO_CONSOLE_DOMAIN
# echo $MINIO_API_DOMAIN

red_echo() {
    printf "\033[31m%s\033[0m" "$*"
}
green_echo() {
    printf "\033[32m%s\033[0m" "$*"
}

# ------------------------------
# dry-run
# ------------------------------

sudo "$DOCKER_COMPOSE" run --rm \
    certbot certonly --webroot \
    --webroot-path /var/www/certbot/ \
    --agree-tos \
    --no-eff-email \
    -m "$LETSENCRYPT_EMAIL" \
    -d "$MINIO_CONSOLE_DOMAIN" \
    --dry-run

sudo "$DOCKER_COMPOSE" run --rm \
    certbot certonly --webroot \
    --webroot-path /var/www/certbot/ \
    --agree-tos \
    --no-eff-email \
    -m "$LETSENCRYPT_EMAIL" \
    -d "$MINIO_API_DOMAIN" \
    --dry-run

# ------------------------------
# rm dummy files
# ------------------------------

sudo "$DOCKER_COMPOSE" exec nginx rm -r /etc/nginx/ssl/live
green_echo "dummy tls certifates have been deleted"

# ------------------------------
# apply
# ------------------------------

sudo "$DOCKER_COMPOSE" run --rm \
    certbot certonly --webroot \
    --webroot-path /var/www/certbot/ \
    --agree-tos \
    --no-eff-email \
    -m "$LETSENCRYPT_EMAIL" \
    -d "$MINIO_CONSOLE_DOMAIN"

sudo "$DOCKER_COMPOSE" run --rm \
    certbot certonly --webroot \
    --webroot-path /var/www/certbot/ \
    --agree-tos \
    --no-eff-email \
    -m "$LETSENCRYPT_EMAIL" \
    -d "$MINIO_API_DOMAIN"

# ------------------------------
# reload nginx
# ------------------------------

sudo "$DOCKER_COMPOSE" exec nginx chown -R nginx:nginx /etc/nginx/ssl/
sudo "$DOCKER_COMPOSE" exec nginx nginx -s reload
