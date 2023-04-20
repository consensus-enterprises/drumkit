#!/bin/sh -eux

# Install docker.

export DEBIAN_FRONTEND=noninteractive
apt-get update -yqq
apt-get install -yqq \
  gnupg \
> /dev/null

mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update -yqq > /dev/null
apt-get install -yqq docker-ce-cli > /dev/null

