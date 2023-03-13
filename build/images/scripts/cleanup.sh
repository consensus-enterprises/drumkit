#!/bin/sh -eux

apt-get -y autoremove;
apt-get -y clean;

rm -rf /tmp/*

