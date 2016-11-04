FROM ubuntu:16.04

MAINTAINER Deni Permana <deni.permana@olx.co.id>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -y install \
            apache2 \
            php7.0 \
            libapache2-mod-php7.0 \
            php7.0-cli \
            php7.0-curl \
            php7.0-dom \
            php7.0-gd \
            php7.0-mbstring \
            php7.0-mcrypt \
            php7.0-imap \
            php7.0-json \
            php7.0-tidy

RUN apt-get -y install \
                unzip \
                zip \
                vim-tiny \
                rsync \
                git

# Configuration
ADD config/docker/apache2/000-default.conf /etc/apache2/sites-available/000-default.conf

RUN a2enmod rewrite
RUN a2enmod headers

# Composer Setup
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer
RUN php -r "unlink('composer-setup.php');"

RUN composer global require "hirak/prestissimo:^0.3"


RUN cd /var/www && git clone https://github.com/denipermana01/cicd.git && cd cicd && composer install --prefer-dist -vvv


##CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]

# Expose Port
EXPOSE 80

# Cleaning up
RUN apt-get autoremove -y
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*
