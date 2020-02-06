#!/bin/sh -eux

export DEBIAN_FRONTEND=noninteractive
apt-get -yqq update
apt-get -yqq install \
  apache2 \
  mysql-client \
  php-curl \
  php-mbstring \
  php-dom \
  php-mysql \
  php-cli \
  php-gd \
  php-xml \
  libapache2-mod-php \
> /dev/null
