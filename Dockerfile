FROM debian:buster

LABEL maintainer="tjwclement@gmail.com"

EXPOSE 80 443

COPY srcs srcs

# installing everything
RUN apt update \
    && apt -y upgrade \
    && apt -y install apt-utils \
    && apt -y install nginx \
    && apt -y install mariadb-server \
    && apt -y install php-fpm php-mysql \
    && apt install openssl \
    && apt -y install wget \
    && apt -y install php-mbstring lsb-release gnupg \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# setting up Nginx
RUN cp srcs/nginx_config /etc/nginx/sites-available/default \
    && rm /var/www/html/index.nginx-debian.html 

# SSL
RUN cd /etc/ssl/certs/ \
    && openssl req -x509 -days 365 -out ft_server.crt -keyout ft_server.key -newkey rsa:2048 -nodes -sha256 \
        -subj "/C=NL/ST=Noord-Holland/L=Amsterdam/O=Codam/CN=ft_server" \
    && chmod 775 /etc/ssl/certs/ft_server.key \
    && chmod 775 /etc/ssl/certs/ft_server.crt

# PHPMyAdmin
RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.6/phpMyAdmin-4.9.6-all-languages.tar.gz \
    && tar -xzvf phpMyAdmin-4.9.6-all-languages.tar.gz -C /var/www/html \
    && mv /var/www/html/phpMyAdmin-4.9.6-all-languages /var/www/html/phpmyadmin \
    && rm phpMyAdmin-4.9.6-all-languages.tar.gz \
    && cp srcs/config.inc.php /var/www/html/phpmyadmin \
    && mkdir /var/www/html/phpmyadmin/tmp \
    && chmod 777 /var/www/html/phpmyadmin/tmp \
    && chmod 660 /var/www/html/phpmyadmin/config.inc.php 

# MySQL
RUN service mysql start \
	&& mysql -u root < /var/www/html/phpmyadmin/sql/create_tables.sql \
	&& mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'wordpressuser'@'localhost' IDENTIFIED BY 'mysql' WITH GRANT OPTION;" \
    && mysql -e "FLUSH PRIVILEGES;" \
	&& mysql -e "CREATE DATABASE wordpress;" \
    && mysql -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpressuser'@'localhost' IDENTIFIED BY 'mysql';" \
    && mysql -e "FLUSH PRIVILEGES;" 

# Wordpress
RUN service mysql start \
    && wget -P /var/www/html/ https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x /var/www/html/wp-cli.phar \
	&& mv /var/www/html/wp-cli.phar /usr/local/bin/wp \
	&& cd /var/www/html/ \
	&& wp core download --allow-root \
	&& wp config create --dbname=wordpress --dbuser=wordpressuser --dbpass=mysql --allow-root \
	&& wp core install --allow-root --url=localhost  --title="My awesome ft_server project!" --admin_user=wordpressuser --admin_password=mysql --admin_email=tjwclement@gmail.com \
	&& mysql -e "USE wordpress;UPDATE wp_options SET option_value='https://localhost/' WHERE option_name='siteurl' OR option_name='home';" 

# give ownership to webroot
RUN chown -R www-data:www-data /var/www/ 

# starting services
CMD bash srcs/ft_server.sh 


# build and run:
# docker build -t ft_server .
# docker run --name ft_server -it  -p 80:80 -p 443:443 ft_server

# change autoindex:
# docker exec -it ft_server /bin/bash srcs/autoindex_on.sh
# docker exec -it ft_server /bin/bash srcs/autoindex_off.sh

# quit:
# close container in Docker Desktop
# docker system prune -a

# Resources:
# installation: https://www.digitalocean.com/community/tutorials/how-to-install-linux-nginx-mariadb-php-lemp-stack-on-debian-10
# For SSL : https://www.digicert.com/easy-csr/openssl.htm
# WP-CLI: https://developer.wordpress.org/cli/commands/core/install/
# making wp-config.php: https://developer.wordpress.org/cli/commands/config/create/
# changing WP url: https://wpbeaches.com/updating-wordpress-mysql-database-after-moving-to-a-new-url/
# MySQL fixing database: https://askubuntu.com/questions/261858/the-phpmyadmin-configuration-storage-is-not-completely-configured