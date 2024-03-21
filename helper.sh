#!/bin/sh

case $1 in
apply)
    sh ./shell/apply-tls.sh
    ;;
renew)
    sh ./shell/renew-tls.sh
    ;;
*)
    echo "Usage: sh helper.sh [apply|renew]"
    ;;
esac
