FROM debian:buster

LABEL maintainer="tjwclement@gmail.com"

EXPOSE 80

COPY srcs srcs

# installing everything
RUN apt update
RUN apt -y upgrade
RUN apt -y install nginx
RUN apt -y install mariadb-server
RUN apt -y install php-fpm php-mysql

# setting up Nginx
RUN mkdir /var/www/localhost
RUN chown -R $USER:$USER /var/www/localhost
RUN cp srcs/nginx_config /etc/nginx/sites-available/localhost 
RUN ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/
ENTRYPOINT service nginx start && bash


# docker build -t ft_server .
# docker run -it -p80:80 ft_server
