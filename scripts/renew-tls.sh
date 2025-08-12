#!/bin/sh

# Run this script to renew tls certs.

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

sudo "$DOCKER_COMPOSE" run --rm certbot renew --dry-run

# ------------------------------
# renew
# ------------------------------

sudo "$DOCKER_COMPOSE" run --rm certbot renew

# ------------------------------
# reload nginx
# ------------------------------

sudo "$DOCKER_COMPOSE" exec nginx chown -R nginx:nginx /etc/nginx/ssl/
sudo "$DOCKER_COMPOSE" exec nginx nginx -s reload
