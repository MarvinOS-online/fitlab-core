#!/bin/bash

CERT_DIR="/certs"
NGINX_REPO_CONFIGS="/nginx_repo_configs"
NGINX_ETC_DIR="/nginx"
NGINX_REPO_HTML="/nginx_repo_html"
PUBLIC_HTML_DIR="/html"


# Make me some certs
if [ ! -f "$CERT_DIR/certificate.crt" ] || [ ! -f "$CERT_DIR/private.key" ]; then
    echo "Certificates not found, generating new ones..."
    mkdir -p "$CERT_DIR"
    
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout "$CERT_DIR/private.key" \
        -out "$CERT_DIR/certificate.crt" \
        -subj "/C=US/ST=State/L=City/O=LLM-Docker-Easy/CN=*" \
        -addext "subjectAltName=DNS:*,IP:0.0.0.0"
    
    chmod 644 "$CERT_DIR/certificate.crt"
    chmod 600 "$CERT_DIR/private.key"
    
    echo "Certificates generated successfully in $CERT_DIR"
else
    echo "Certificates already exist in $CERT_DIR"
fi

#Copy the NGINX configs and any websites
cp -r $NGINX_REPO_CONFIGS/* $NGINX_ETC_DIR/.
cp -r $NGINX_REPO_HTML/* $PUBLIC_HTML_DIR/.
chmod -R 644 $PUBLIC_HTML_DIR/*
chmod 755 $PUBLIC_HTML_DIR
chmod 755 $PUBLIC_HTML_DIR/images
