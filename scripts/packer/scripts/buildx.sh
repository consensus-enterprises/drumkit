#!/bin/sh -eux

# Install docker buildx plugin.

export DEBIAN_FRONTEND=noninteractive
apt-get update -yqq
apt-get install -yqq \
  docker-buildx-plugin \
> /dev/null
