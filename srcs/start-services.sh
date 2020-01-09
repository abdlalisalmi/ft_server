
#MYSQL INSTALATION
apt-get install -y lsb-release
apt-get install -y debconf-utils
apt-get update
expect -c "
    set timeout 10
    spawn dpkg -i mysql-apt-config_0.8.14-1_all.deb
    expect \"Which MySQL product do you wish to configure?\"
    send \"1\r\"
    expect \"Which server version do you wish to receive?\"
    send \"1\r\"
    expect \"Which MySQL product do you wish to configure?\"
    send \"4\r\"
    expect EOF
 "
export DEBIAN_FRONTEND=noninteractive
echo "mysql-server mysql-server/root_password password root" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections

apt-get update
apt-get install -y mysql-server

chown -R mysql: /var/lib/mysql && service mysql start

mysql -uroot -proot -e "CREATE DATABASE wp_db"
mysql -uroot -proot -e "CREATE USER 'admin'@'localhost' IDENTIFIED BY 'admin'"
mysql -uroot -proot -e "GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost'"
mysql -uadmin -padmin  wp_db <wp_db.sql

# services restart
chown -R mysql: /var/lib/mysql && service mysql restart
service php7.3-fpm start
service nginx restart

/bin/bash
