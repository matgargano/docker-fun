#!/bin/bash

# Start Nginx with the initial non-SSL configuration
envsubst '$DOMAIN_NAME' < /etc/nginx/nginx.conf.tpl > /etc/nginx/nginx.conf
nginx &

# Wait for Nginx to start
sleep 5

# Obtain the SSL certificate
certbot --nginx -d $DOMAIN_NAME -m $EMAIL --agree-tos --no-eff-email --keep-until-expiring --redirect --non-interactive

# Stop Nginx
nginx -s stop

# Switch to the SSL configuration
envsubst '$DOMAIN_NAME' < /etc/nginx/nginx.conf.ssl.tpl > /etc/nginx/nginx.conf

# Restart Nginx with SSL configuration
nginx -g 'daemon off;'
