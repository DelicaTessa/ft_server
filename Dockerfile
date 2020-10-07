FROM debian:buster

ENV PASSWORD mysql

LABEL maintainer="tjwclement@gmail.com"

EXPOSE 80

COPY srcs srcs

# installing everything
RUN apt update 
RUN apt -y upgrade
RUN apt -y install apt-utils
RUN apt -y install sudo
RUN apt -y install nginx 
RUN apt -y install mariadb-server 
RUN apt -y install php-fpm php-mysql 
RUN apt install openssl
RUN apt -y install wget
RUN apt-get install php-mbstring lsb-release gnupg  -y 

# setting up Nginx
RUN mkdir /var/www/ft_server
RUN cp srcs/nginx_config /etc/nginx/sites-available/default
RUN echo 'Welcome to my ft_server project!' > /var/www/ft_server/index.html

# SSL
RUN openssl req -new -newkey rsa:2048 -nodes -out ft_server.csr -keyout ft_server.key -subj "/C=NL/ST=Noord-Holland/L=Amsterdam/O=Codam/CN=ft_server"

# Wordpress
RUN wget https://wordpress.org/latest.tar.gz
RUN tar -xvf latest.tar.gz
RUN mv wordpress /var/www/html
RUN rm latest.tar.gz
RUN cp srcs/wp-config.php wordpress
RUN mkdir /usr/bin/wp
RUN wget -P /usr/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x /usr/bin/wp/wp-cli.phar


# PHPMyAdmin
RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.5/phpMyAdmin-4.9.5-all-languages.tar.gz
RUN tar -xzvf phpMyAdmin-4.9.5-all-languages.tar.gz -C /var/www/html/
RUN mv /var/www/html/phpMyAdmin-4.9.5-all-languages /var/www/html/phpmyadmin
RUN rm phpMyAdmin-4.9.5-all-languages.tar.gz
RUN cp srcs/config.inc.php /var/www/html/phpmyadmin
RUN mkdir /var/www/html/phpmyadmin/tmp
RUN chmod 777 /var/www/html/phpmyadmin/tmp

# give permission
RUN chown -R www-data:www-data /var/www/html/*

CMD service nginx start \
&& service mysql start \
&& service php7.3-fpm start \
&& service sudo start \
&& sudo mysql -u root -p${PASSWORD} -e "CREATE DATABASE wordpress;" \
&& sudo mysql -u root -p${PASSWORD} -e "CREATE USER 'wordpressuser'@'localhost' IDENTIFIED BY '${PASSWORD}';" \
&& sudo mysql -u root -p${PASSWORD} -e "GRANT ALL ON wordpress.* TO 'wordpressuser'@'localhost' IDENTIFIED BY '${PASSWORD}' WITH GRANT OPTION;" \
&& sudo mysql -u root -p${PASSWORD} -e "FLUSH PRIVILEGES;"\
&& bash

# && tail -f /dev/null


# first install Docker Desktop
# build and run:
# docker build -t ft_server .
# docker run -it -p80:80 ft_server

# login phpMyAdmin:
# username: wordpressuser
# password: mysql

# quit:
# close container in Docker Desktop
# docker system prune -a

# Resources:
# installation: https://www.digitalocean.com/community/tutorials/how-to-install-linux-nginx-mariadb-php-lemp-stack-on-debian-10
# For SSL : https://www.digicert.com/easy-csr/openssl.htm
