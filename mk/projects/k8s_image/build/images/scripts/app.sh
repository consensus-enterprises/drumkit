#!/bin/sh -eux

# Install app dependencies.

apt-get update
apt-get -yqq install \
  mariadb-client
