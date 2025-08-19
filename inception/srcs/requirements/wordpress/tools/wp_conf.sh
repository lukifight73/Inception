#!/bin/bash
set -euo pipefail #en cas de fail

# Wait for MariaDB
until mysqladmin ping -h mariadb --silent; do sleep 1; done

cd /var/www/wordpress

# Install WP-CLI only if not present
if [ ! -f "/usr/local/bin/wp" ]; then
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi
#"Une fois WP-CLI installé, le script l’utilise pour automatiser
#toute l’installation de WordPress : il télécharge les fichiers,
#onfigure la base de données et crée l’admin automatiquement,
# sans avoir besoin d’ouvrir un navigateur."

# Download WordPress only if not present
if [ ! -f "wp-config.php" ]; then
    wp core download --allow-root
    wp core config --dbhost=mariadb:3306 --dbname="$MYSQL_DB" --dbuser="$MYSQL_USER" --dbpass="$MYSQL_PASSWORD" --allow-root
    wp core install --url="$DOMAIN_NAME" --title="$WP_TITLE" --admin_user="$WP_ADMIN_N" --admin_password="$WP_ADMIN_P" --admin_email="$WP_ADMIN_E" --allow-root

    # Create user only if doesn't exist
    if ! wp user get "$WP_U_NAME" --allow-root >/dev/null 2>&1; then
        wp user create "$WP_U_NAME" "$WP_U_EMAIL" --user_pass="$WP_U_PASS" --role="$WP_U_ROLE" --allow-root
    fi
fi

# Set permissions
chmod -R 755 /var/www/wordpress/
chown -R www-data:www-data /var/www/wordpress

# Create PHP-FPM directory
mkdir -p /run/php

# Start PHP-FPM in foreground
exec /usr/sbin/php-fpm7.4 -F

# #---------------------------------------------------wp installation---------------------------------------------------#
# # wp-cli installation
# curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
# # wp-cli permission
# chmod +x wp-cli.phar
# # wp-cli move to bin
# mv wp-cli.phar /usr/local/bin/wp

# # go to wordpress directory
# cd /var/www/wordpress

# #---------------------------------------------------wp installation---------------------------------------------------##---------------------------------------------------wp installation---------------------------------------------------#
# if [ ! -f wp-config.php ]; then
#     # download wordpress core files
#     wp core download --allow-root
#     # create wp-config.php file with database details
#     wp core config --dbhost=mariadb:3306 --dbname="$MYSQL_DB" --dbuser="$MYSQL_USER" --dbpass="$MYSQL_PASSWORD" --allow-root
#     # install wordpress with the given title, admin username, password and email
#     wp core install --url="https://$DOMAIN_NAME:8443" --title="$WP_TITLE" --admin_user="$WP_ADMIN_N" --admin_password="$WP_ADMIN_P" --admin_email="$WP_ADMIN_E" --allow-root
#     wp option update siteurl "https://${DOMAIN_NAME}:8443" --allow-root
#     wp option update home "https://${DOMAIN_NAME}:8443" --allow-root
#     #create a new user with the given username, email, password and role
#     wp user create "$WP_U_NAME" "$WP_U_EMAIL" --user_pass="$WP_U_PASS" --role="$WP_U_ROLE" --allow-root
# fi

# # give permission to wordpress directory
# chmod -R 777 /var/www/wordpress/
# # change owner of wordpress directory to www-data
# chown -R www-data:www-data /var/www/wordpress

# #---------------------------------------------------php config---------------------------------------------------#

# # create a directory for php-fpm
# mkdir -p /run/php
# # start php-fpm service in the foreground to keep the container running
# /usr/sbin/php-fpm7.4 -F
