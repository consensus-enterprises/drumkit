#!/bin/sh -eux

# Install base utilities.

apt-get -yqq install \
  curl \
  git \
  htop \
  make \
  patch \
  procps \
  screen \
  strace \
  sudo \
  unzip \
  tree \
  vim-tiny

