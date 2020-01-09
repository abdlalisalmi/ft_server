FROM debian:buster

EXPOSE 80 443

# UPDATE AND INSTALL PACKAGES
RUN apt-get update
RUN apt-get upgrade
RUN apt-get -y install php7.3-fpm php7.3-common php7.3-mysql php7.3-xml php7.3-xmlrpc php7.3-curl php7.3-gd php7.3-imagick php7.3-cli php7.3-dev php7.3-imap php7.3-mbstring php7.3-opcache php7.3-soap php7.3-zip unzip -y
RUN apt-get install -y wget
RUN apt-get install -y expect
RUN apt-get install -y vim

#COPY FILES TO SERVER
COPY srcs/mysql-apt-config_0.8.14-1_all.deb ./
COPY srcs/start-services.sh ./
COPY srcs/wordpress.tar.gz ./
COPY srcs/wp_db.sql ./

#SSL CONFIGURE
COPY srcs/localhost.crt ./etc/ssl/certs/localhost.crt
COPY srcs/localhost.key ./etc/ssl/private/localhost.key

#INGINX INSTALATION & CONFIGIRATION
RUN apt-get install -y nginx
COPY srcs/default etc/nginx/sites-available/
RUN service nginx start

#PHPMYADMIN INSTALATION & CONFIGIRATION
RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-english.tar.gz
RUN tar -xvf phpMyAdmin-4.9.0.1-english.tar.gz
RUN mv phpMyAdmin-4.9.0.1-english phpmyadmin
RUN cp -r phpmyadmin /var/www/html/

#WORDPRESS INSTALL
RUN tar -xvf wordpress.tar.gz
RUN cp -r wordpress /var/www/html/
RUN rm wordpress.tar.gz
RUN rm /var/www/html/wordpress/wp-config-sample.php
COPY srcs/wp-config.php /var/www/html/wordpress/

#MYSQL INSTALATION & START SERVICES
CMD bash start-services.sh