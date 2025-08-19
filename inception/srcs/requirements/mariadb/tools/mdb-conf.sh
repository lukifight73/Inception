#!/bin/bash

#--------------mariadb start--------------#

# Initialize DB if not exists
if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# Start mysqld in background
mysqld_safe --datadir='/var/lib/mysql' &

# Wait for mysqld to be ready
until mysqladmin ping >/dev/null 2>&1; do
    sleep 1
done

#--------------mariadb config--------------#
# Configure DB only on first run
if [ ! -f "/var/lib/mysql/.configured" ]; then
    mysql -u root << EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DB}\`;
CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DB}\`.* TO \`${MYSQL_USER}\`@'%';
FLUSH PRIVILEGES;
EOF
    touch /var/lib/mysql/.configured
fi

# Stop background process
mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown

# Start in foreground
exec mysqld_safe --bind-address=0.0.0.0 --datadir='/var/lib/mysql'


# #--------------mariadb config--------------#
# # Create database named variable MYSQL_DB if not exists
# mariadb -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DB}\`;"

# # Create user if not exists (@'%' permet d'acceder a l'utilisateur depuis toute IP)
# mariadb -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"

# # Grant all privileges to user
# mariadb -e "GRANT ALL PRIVILEGES ON ${MYSQL_DB}.* TO \`${MYSQL_USER}\`@'%';"

# # Permet d'appliquer les changements immediatement en rechargeant les tables d'autorisations de MariaDB
# mariadb -e "FLUSH PRIVILEGES;"

# CREATE USER 'user'@'172.20.0.%' IDENTIFIED BY 'password';
# GRANT ALL PRIVILEGES ON *.* TO 'user'@'172.20.0.%' WITH GRANT OPTION;
# FLUSH PRIVILEGES;

# #--------------mariadb restart--------------#
# # Shutdown mariadb to restart with new config
# mysqladmin -u root -p$MYSQL_ROOT_PASSWORD shutdown

# # Restart mariadb with new config in the background to keep the container running
# # mysqld_safe start le server MaariaDB en safe mode = si une erreur apparait pendant le startup, ca va restart automatiquement.
# # --port=3306 c'est le port sur lequel MariaDB va ecouter pour les connections entrantes
# # --bind-address=0.0.0.0 c'est les ID sur lesquelles mariaDB accepte les connections :
# # 0.0.0.0 signifie que mariaDB accept toutes les connexions, peu importe leur IP
# # --datadir='/var/lib/mysql' --> cette option permet de set l'endroit ou MariaDB va stocker ses datas.

# mysqld_safe
