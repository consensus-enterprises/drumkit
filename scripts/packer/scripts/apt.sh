#!/bin/sh -eux

# Update the package list
export DEBIAN_FRONTEND=noninteractive
apt-get -yqq update

# Keep package installations to the minimum
cat > /etc/apt/apt.conf.d/01norecommend << EOF
APT::Install-Recommends "0";
APT::Install-Suggests "0";
EOF

apt-get -y -qq install \
  apt-utils \
  apt-transport-https \
  ca-certificates \
> /dev/null
