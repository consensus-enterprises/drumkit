---
title: Usage
weight: 10

---

GNU Make
--------

Most Drupal platform creation refers to Drush makefiles. Drumkit includes a set
of [GNU Make](https://www.gnu.org/software/make/)files. Familiarity with Make
will allow you to extend and override Drumkit's functionality. However, for
normal usage all you need to know is that all commands are prefaced by `make`,
which invokes GNU Make.


Help
----

To see what commands are available, run:

```console
$ make help
make help
  Print this help message.
make tools-help
  Print install help for all tools.
make drupal
  Build a Drupal codebase, install a site and start a web server.
make kill-server
  Stop the server running started during site install.
make install
  Install all tools.
make test
  Run tests.
make vagrant
  Add a Vagrantfile.
make up
  Launch Vagrant.
make rebuild
  Destroy the current Vagrant VM and re-provision a new one.
```

To see the tools that `drumkit` can install, and options related to them, run:

```console
$ make tools-help
make composer
  Install Composer.
make composer COMPOSER_REL=1.0.0-beta1
  Install the 1.0.0-beta1 release of Composer.
make drush
  Install Drush.
make drush DRUSH_REL=8.0.5
  Install the 8.0.5 release of Drush.
make behat
  Install Behat.
make selenium
  Install Selenium.
```

