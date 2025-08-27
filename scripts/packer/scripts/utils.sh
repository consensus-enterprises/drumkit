#!/bin/sh -eux

# Install base utilities.

export DEBIAN_FRONTEND=noninteractive
apt-get update -yqq
apt-get install -yqq \
  curl \
  git \
  make \
  patch \
  sudo \
  unzip \
  vim-tiny \
  wget \
> /dev/null
