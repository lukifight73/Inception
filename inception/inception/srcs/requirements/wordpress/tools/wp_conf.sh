#!/bin/bash
set -euo pipefail #en cas de fail

#Wait for MariaDB
until nc -z mariadb 3306; do sleep 1; done

#---------------------------------------------------wp installation---------------------------------------------------#
# wp-cli installation
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
# wp-cli permission
chmod +x wp-cli.phar
# wp-cli move to bin
mv wp-cli.phar /usr/local/bin/wp

# go to wordpress directory
cd /var/www/wordpress

#---------------------------------------------------wp installation---------------------------------------------------##---------------------------------------------------wp installation---------------------------------------------------#
if [ ! -f wp-config.php ]; then
    # download wordpress core files
    wp core download --allow-root
    # create wp-config.php file with database details
    wp core config --dbhost=mariadb:3306 --dbname="$MYSQL_DB" --dbuser="$MYSQL_USER" --dbpass="$MYSQL_PASSWORD" --allow-root
    # install wordpress with the given title, admin username, password and email
    wp core install --url="$DOMAIN_NAME" --title="$WP_TITLE" --admin_user="$WP_ADMIN_N" --admin_password="$WP_ADMIN_P" --admin_email="$WP_ADMIN_E" --allow-root
    #create a new user with the given username, email, password and role
    wp user create "$WP_U_NAME" "$WP_U_EMAIL" --user_pass="$WP_U_PASS" --role="$WP_U_ROLE" --allow-root
fi

# give permission to wordpress directory
chmod -R 777 /var/www/wordpress/
# change owner of wordpress directory to www-data
chown -R www-data:www-data /var/www/wordpress

#---------------------------------------------------php config---------------------------------------------------#

# create a directory for php-fpm
mkdir -p /run/php
# start php-fpm service in the foreground to keep the container running
/usr/sbin/php-fpm7.4 -F