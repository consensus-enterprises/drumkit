---
title: Drupal 8 Project Type
weight: 10

---

`make init-project-drupal8`
---------------------------

This will initialize a [Lando](https://lando.dev)-based Drupal 8 project, using
the standard [Composer](https://getcomposer.org) `composer create-project`
workflow to initialize a Drupal codebase from the standard
[`drupal-composer/drupal-project`](https://github.com/drupal-composer/drupal-project)

**NB** As of Drupal 8.8.0, this [composer template is
deprecated](https://www.drupal.org/docs/develop/using-composer/using-composer-to-install-drupal-and-manage-dependencies) in favour of
[`drupal/recommended-project`](https://github.com/drupal/recommended-project).
Drumkit will shortly update this and/or make the composer template configurable
with sane default.

To bootstrap a Drupal 8 project with Drumkit:

```
mkdir myproject
cd myproject
git init

wget -O - https://drumk.it/installer | /bin/bash
. d
make init-project-drupal8
```

This will prompt you for some information to populate your project:

* Project name (no spaces), which will become the first part of the **`https://[projectname].lndo.site`** URL that Lando assigns to your project. 
* Site name, the human-readable name for the site (used for `make install` command, etc.)
* Database credentials, to feed to Lando to setup and wire into the Drupal install (settings.php)
* Admin username and password for the site once installed.

Each of these has a default value, and once you've entered all of them, Drumkit
will proceed with ensuring you have the relevant dependencies to initialize the
project- primarily this is Python3 (for Jinja2 templating), plus Behat, Docker,
and Lando.

If any packages are missing you may be prompted by `sudo` for your
user password so `apt` can install them. Then it will call the `composer
create-project` command to initialize the codebase. Finally it will create a
handful of default make targets, in the following files, and initialize your
`.lando.yml`:

* `~myproject/.mk/mk.d/20_lando.mk` - lando targets like `make start` and `make stop`
* `~myproject/.mk/mk.d/30_build.mk` - composer targets like `make build` and `make update`
* `~myproject/.mk/mk.d/40_install.mk` - drush targets like `make install`

Once complete, you have a fully loaded Drumkit setup to drive your Lando Drupal
local dev site.

```
  make start   # Start Lando containers
  make build   # Build composer codebase
  make install # Run Drupal installer (via drush)
```

This will get you a working site at https://[projectname].lndo.site.
