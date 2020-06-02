#!/usr/bin/env bash

set -e

COUNTRY="${COUNTRY:-"US"}"
STATE="${STATE:-"Pennsylvania"}"
LOCALITY="${LOCALITY:-"Philadelphia"}"
ORGANIZATION="${ORGANIZATION:-"MYCORP"}"
ORGANIZATION_UNIT="${ORGANIZATION_UNIT:-"IT"}"
COMMON_NAME="${COMMON_NAME:-"www.example.com"}"
SUBJECT_ALTERNATIVE_NAME="${SUBJECT_ALTERNATIVE_NAME:-"DNS:www.example.com"}"

setup_ssl() {
    if [[ ! -f /etc/nginx/ssl/dhparam ]]; then
        if ! curl -vs https://ssl-config.mozilla.org/ffdhe2048.txt > /etc/nginx/ssl/dhparam; then
            openssl dhparam -out /etc/nginx/ssl/dhparam 2048
        fi
    fi
    if [[ ! -f /etc/nginx/ssl/key.pem ]]; then
        openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
            -keyout /etc/nginx/ssl/key.pem \
            -out /etc/nginx/ssl/server.pem.crt \
            -subj "/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORGANIZATION/OU=$ORGANIZATION_UNIT/CN=$COMMON_NAME" \
            -reqexts SAN -extensions SAN \
            -config <(cat /etc/ssl/openssl.cnf \
                <(printf "\n[SAN]\nsubjectAltName=$SUBJECT_ALTERNATIVE_NAME"))
        
        if [[ ! -f /etc/nginx/ssl/root_CA_cert_plus_intermediates.pem.crt ]]; then
            # we copy this just so that the nginx configuration will have a file to look at
            cp /etc/nginx/ssl/server.pem.crt /etc/nginx/ssl/root_CA_cert_plus_intermediates.pem.crt
        fi
    fi
}

run() {
    setup_ssl
}

run "$@"
