# README

Deploy [MinIO](https://min.io/) with Docker Compose.

## Docker Compose

Edit `.env` to configure env vars available in `compose.yaml`.\
Duplicate [template.env](./template.env) as `.env` to get started.

## Nginx

By default, template files in `/etc/nginx/templates/*.template` will be read\
and the result of executing `envsubst` will be output to `/etc/nginx/conf.d/`.\
See more in [Using environment variables in nginx configuration (new in 1.19)](https://hub.docker.com/_/nginx#:~:text=Using%20environment%20variables%20in%20nginx%20configuration%20(new%20in%201.19)).

## Certbot

## Cloudflare Tunnel
