#!/bin/sh

# run this script to apply free tls certs.

# get env vars.
. ./.env
# echo $MINIO_CONSOLE_DOMAIN
# echo $MINIO_API_DOMAIN

red_echo() {
    echo -e "\033[31m$@\033[0m"
}
green_echo() {
    echo -e "\033[32m$@\033[0m"
}

######### dry-run #########>
sudo $DOCKER_COMPOSE run --rm \
    certbot certonly --webroot \
    --webroot-path /var/www/certbot/ \
    --agree-tos \
    --no-eff-email \
    -m $LETSENCRYPT_EMAIL \
    -d $MINIO_CONSOLE_DOMAIN \
    --dry-run

if [ $? -ne 0 ]; then
    red_echo "failed to apply tls certificates for:"
    red_echo $MINIO_CONSOLE_DOMAIN
    exit 1
fi

sudo $DOCKER_COMPOSE run --rm \
    certbot certonly --webroot \
    --webroot-path /var/www/certbot/ \
    --agree-tos \
    --no-eff-email \
    -m $LETSENCRYPT_EMAIL \
    -d $MINIO_API_DOMAIN \
    --dry-run

if [ $? -ne 0 ]; then
    red_echo "failed to apply tls certificates for:"
    red_echo $MINIO_API_DOMAIN
    exit 1
fi
######### dry-run #########<

######### rm dummy files #########>
sudo $DOCKER_COMPOSE exec nginx rm -r /etc/nginx/ssl/live
green_echo "dummy tls certifates have been deleted"
######### rm dummy files #########<

######### apply #########>
sudo $DOCKER_COMPOSE run --rm \
    certbot certonly --webroot \
    --webroot-path /var/www/certbot/ \
    --agree-tos \
    --no-eff-email \
    -m $LETSENCRYPT_EMAIL \
    -d $MINIO_CONSOLE_DOMAIN

if [ $? -ne 0 ]; then
    red_echo "failed to apply tls certificates for:"
    red_echo $MINIO_CONSOLE_DOMAIN
    exit 1
fi

sudo $DOCKER_COMPOSE run --rm \
    certbot certonly --webroot \
    --webroot-path /var/www/certbot/ \
    --agree-tos \
    --no-eff-email \
    -m $LETSENCRYPT_EMAIL \
    -d $MINIO_API_DOMAIN

if [ $? -ne 0 ]; then
    red_echo "failed to apply tls certificates for:"
    red_echo $MINIO_API_DOMAIN
    exit 1
fi
######### apply #########<

######### reload nginx #########<
sudo $DOCKER_COMPOSE exec nginx chown -R nginx:nginx /etc/nginx/ssl/
sudo $DOCKER_COMPOSE exec nginx nginx -s reload

if [ $? -ne 0 ]; then
    red_echo ":: failed to reload nginx"
    exit 1
fi
######### reload nginx #########<
