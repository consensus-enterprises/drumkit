#!/bin/sh -eux

# Use this file for projects that use php on the command line, but don't involve web development;
# for web development projects, use "php.sh" (the default).

export DEBIAN_FRONTEND=noninteractive
apt-get -yqq update
# Install Behat dependencies:
apt-get -yqq install \
  curl \
  php-cli \
  php-mbstring \
  php-curl \
  php-xml \
  php-gd \
> /dev/null
