#!/bin/bash

cd /vagrant

sudo make deps

make bashrc
. ~/.bashrc

make install

make drupal

