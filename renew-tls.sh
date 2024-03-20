#!/bin/sh

# run this script to renew tls certs.

# it's recommended to add the following lines in crontab:
# renew every 2 months (on the first day of the month).
# 0 0 1 */2 * cd [this-repository] && sh renew-tls.sh

# get env vars.
. ./.env
# echo $MINIO_CONSOLE_DOMAIN
# echo $MINIO_API_DOMAIN

######### dry-run #########>
sudo $DOCKER_COMPOSE run --rm certbot renew --dry-run

if [ $? -ne 0 ]; then
    red_echo ":: failed to renew tls certificates"
    exit 1
fi
######### dry-run #########<

######### renew #########>
sudo $DOCKER_COMPOSE run --rm certbot renew

if [ $? -ne 0 ]; then
    red_echo ":: failed to renew tls certificates"
    exit 1
fi
######### renew #########<

######### reload nginx #########<
sudo $DOCKER_COMPOSE exec nginx nginx -s reload

if [ $? -ne 0 ]; then
    red_echo ":: failed to reload nginx"
    exit 1
fi
######### reload nginx #########<
