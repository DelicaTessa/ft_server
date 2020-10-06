FROM debian:buster-backports

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
RUN apt install nano 
RUN apt install openssl
RUN apt -y install wget

# setting up Nginx
RUN mkdir /var/www/ft_server
RUN cp srcs/nginx_config /etc/nginx/sites-available/default
RUN echo 'Welcome to my ft_server project!' > /var/www/ft_server/index.html

# SSL
RUN openssl req -new -newkey rsa:2048 -nodes -out ft_server.csr -keyout ft_server.key -subj "/C=NL/ST=Noord-Holland/L=Amsterdam/O=Codam/CN=ft_server"

# Wordpress
RUN mkdir ft_server
RUN wget -P ft_server https://wordpress.org/latest.tar.gz
RUN tar -xvf ft_server/latest.tar.gz
RUN rm ft_server/latest.tar.gz

# PHPMyAdmin
RUN wget -P ft_server https://files.phpmyadmin.net/phpMyAdmin/4.9.5/phpMyAdmin-4.9.5-all-languages.tar.gz
RUN tar -xzvf ft_server/phpMyAdmin-4.9.5-all-languages.tar.gz
RUN rm ft_server/phpMyAdmin-4.9.5-all-languages.tar.gz

ENTRYPOINT service nginx start \
&& service mysql start \
&& service php7.3-fpm start \
&& service sudo start \
&& bash


# first install Docker Desktop
# build and run:
# docker build -t ft_server .
# docker run -it -p80:80 ft_server

# quit:
# close container in Docker Desktop
# docker system prune -a

# Resources:
# For SSL : https://www.digicert.com/easy-csr/openssl.htm

# notities: zet een file (bv index.php) in var/www/ft_server/
