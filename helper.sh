#!/bin/sh

case $1 in
apply)
    sh ./scripts/apply-tls.sh
    ;;
renew)
    sh ./scripts/renew-tls.sh
    ;;
*)
    echo "Usage: sh helper.sh [apply|renew]"
    ;;
esac
