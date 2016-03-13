MAKE SERVER [![Build status](https://travis-ci.org/ergonlogic/make-server.svg)](https://travis-ci.org/ergonlogic/make-server)
===========

Drush Make is certainly quite useful for building Drupal code-bases. A little-known capability is to load project version data from a source other than the official http://updates.drupal.org. This install profile is intended to make it easy to run your own updates service.

Development
-----------

We use a simple Vagrant-based VM that installs Drush and a Drupal site. It
symlinks this project as an install profile, so that simply editing the code in
this directory is sufficient to see the changes.

    $ git clone https://github.com/ergonlogic/make-server.git
    $ cd make-server
    $ vagrant up

If you want to install Drush from sources, instead of the .phar:

    $ DRUSH_DEV=true vagrant up

