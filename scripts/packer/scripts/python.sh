#!/bin/sh -eux

# Install python and related utilities.

export DEBIAN_FRONTEND=noninteractive

apt-get install -yqq \
  python3-minimal \
  python3-pip \
  python3-yaml \
  python3-jinja2 \
  python3-apt \
  python3-setuptools \
  python3-wheel \
> /dev/null
update-alternatives --install /usr/bin/python python /usr/bin/python3 1
pip3 install jinja2-cli matrix-client ansible
