#!/bin/bash

# Set different project roots depending on Vagrant or TravisCI environments.
if [ -z ${TRAVIS_BUILD_DIR+x} ]; then
  cd /vagrant
  make deps
else
  export project_root=$TRAVIS_BUILD_DIR
fi

make init
source ~/.bashrc

make drush

make drupal

make behat

