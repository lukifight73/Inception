#!/bin/bash

# Remplacer le placeholder par la vraie valeur
sed -i "s/DOMAIN_PLACEHOLDER/${DOMAIN_NAME}/g" /etc/nginx/conf.d/default.conf

# Démarrer NGINX
exec nginx -g "daemon off;"
