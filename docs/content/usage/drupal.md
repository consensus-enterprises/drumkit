---
title: Drupal Project Type
weight: 10

---

## Spin up a New DDEV Drupal Project

`make init-project-drupal`

This will initialize a [DDEV](https://ddev.com)-based Drupal 10
project, using the standard [Composer](https://getcomposer.org)
`composer create-project` workflow to initialize a Drupal codebase from the
standard
[`drupal-composer/drupal-project`](https://github.com/drupal-composer/drupal-project)

DDEV is a development wrapper around docker, designed to allow you to rapidly
spin up local development environments. To use drumkit this way, you need to
already have `ddev` and `docker` installed, although Drumkit will attempt a
default installation method for both if it detects they are not available in
your environment. (See the [DDEV](https://ddev.com) or
[Docker](https://docker.com) websites for installation instructions for your
OS.)

To bootstrap a Drupal project with Drumkit:

```
mkdir myproject
cd myproject
git init

wget -O - https://drumk.it/installer | /bin/bash
source d
make init-project-drupal PROJECT_NAME=mydrupal SITE_NAME="My Drupal Site"
```

This will configure and start a DDEV [`drupal10` project
type](https://ddev.readthedocs.io/en/stable/users/configuration/config/#type),
spinning up Docker containers for your project and proceeding to provision an
opinionated set of tools into the new project:

* Drupal Drumkit targets like `make build`, and `make install`
* Provisions a `composer.json` and builds a stock Drupal 10 codebase
* Configures and installs Behat and related FeatureContext classes

### On Linux
If any packages are missing you may be prompted by `sudo` for your user password so `apt` can install them.

### On a Mac
You may need to manually install dependencies using `brew install {package}`.

## Drupal Drumkit targets

Once the DDEV project is configured and started, the `init-drupal-project`
target calls `make drupal-drumkit-dir`, passing your original `PROJECT_NAME`
and `SITE_NAME` variables, which primarily provisions a set of Drumkit `make`
targets that are useful in a Drupal project:

* [`drumkit/mk.d/10_variables.mk`](https://gitlab.com/consensus.enterprises/drumkit/-/blob/main/files/drupal-project/10_variables.mk.tmpl) - Foundational variables for the project (eg. `PROJECT_NAME` and `SITE_NAME` etc.)
* [`drumkit/mk.d/20_ddev.mk`](https://gitlab.com/consensus.enterprises/drumkit/-/blob/main/files/drupal-project/20_ddev.mk) - DDEV targets like `make start` and `make stop`
* [`drumkit/mk.d/30_build.mk`](https://gitlab.com/consensus.enterprises/drumkit/-/blob/main/files/drupal-project/30_build.mk) - composer targets like `make build` and `make update`
* [`drumkit/mk.d/40_install.mk`](https://gitlab.com/consensus.enterprises/drumkit/-/blob/main/files/drupal-project/40_install.mk) - drush targets like `make install`
* [`drumkit/mk.d/50_backup.mk`](https://gitlab.com/consensus.enterprises/drumkit/-/blob/main/files/drupal-project/50_backup.mk) database backup targets like `make snapshot` and `make restore-snapshot`
* [`drumkit/mk.d/60_test.mk`](https://gitlab.com/consensus.enterprises/drumkit/-/blob/main/files/drupal-project/60_test.mk) - targets for running Behat tests

## Composer Drupal 10 codebase

Now `init-drupal-project` will call `composer create-project` to initialize a
Composer codebase for the project. This creates a `composer.json` file as well
as a fully-built `vendor` and `web` directory with basic Drupal dependencies in
place. With this stage complete, your project is ready to run Drupal.

## Behat

Having initialized a Composer codebase, we can pull in some development
dependencies we tend to use heavily, namely [Behat]() (we call `make drupal-behat-deps` as part of `init-project-drupal`).

This creates a series of files, and pulls in some Consensus-grown FeatureContext
libraries to provide step definitions for typical Drupal projects we work on:

* [`behat.yml`](https://gitlab.com/consensus.enterprises/drumkit/-/blob/main/files/drupal-project/behat.yml.tmpl) - the main Behat config file.


(eg.  [consensus/behat-terminal-context](https://packagist.org/packages/consensus/behat-terminal-context) and [consensus/behat-drupal-context](https://packagist.org/packages/consensus/behat-drupal-context)).

## Gitlab CI

Finally `init-project-drupal` installs a basic `.gitlab-ci.yml` configuration
which will leverage a Docker-in-Docker image to run DDEV inside the CI
environment and simply run a `make start build install tests` to run your test
suite the same way you would locally.

## Completed Drumkit Drupal project

Once complete, you have a fully loaded Drumkit setup to drive your DDEV Drupal
local dev site.

```
  make start   # Start DDEV containers
  make build   # Build composer codebase
  make install # Run Drupal installer (via drush)
```

You may need to [roll back your version of PHP](https://stackoverflow.com/questions/34909101/how-can-i-easily-switch-between-php-versions-on-mac-osx) as more recent MacOS ships with PHP 8

This will get you a working site at https://[projectname].ddev.site.

## Development Workflows

Once you have a site instantiated and you begin working on it, there are some
Drumkit targets that are available to you immediately, such as:

1. `make start` && `make stop` - run the corresponding DDEV commands to start and stop the DDEV containers.
1. `make build` - run a composer install based on your current `composer.lock` to ensure you have all the latest packages.
1. `make install` - run a drush site-install with your default PROJECT_NAME and SITE_NAME (and associated variables from `drumkit/mk.d/10_variables.mk`)
1. `make tests` - run Behat against the installed Drupal site
1. `make clean-build` - wipe out your composer.json-installs trees under `vendor/` and `web/`
1. `make snapshot SNAP=<name>` - take an SQL dump of the database, and optionally give it a name
1. `make restore-snapshot SNAP=<name>` - restore a previously-taken snapshot (latest, or as named by SNAP)
1. `make ls-snaps` - show a date-ordered listing of named snapshots in `tmp/backups`
1. `make rm-snap SNAP=<name>` - remove a named snapshot
1. `make rm-all-snaps` - remove ALL snapshots (but not the underlying db dumps)

### Backups and Snapshots

The Drumkit backup/snapshot facility is quite versatile and can speed up
development efforts significantly. We can build the site up to a given point,
test a new feature or build some new functionality, and then quickly roll back
to the earlier point to restart or validate the changes worked.

The underlying mechanism here is very simple. We rely on the `drush sql:dump`
command to generate simple `.sql` file named for the site url and timestamp,
into the `tmp/backups` directory of the project. This provides a "raw" build up
of database dumps over time, and if you only called `make backup` that's all
you'd get.

Layered on top of this is a system to keep named symlinks to the raw
timestamped `.sql` files, through the `make snapshot` and related targets. A
simple `make snapshot` will do the same as a `make backup` but also create a
symlink called `[project].lndo.site-database-latest.sql` to point to the
timestamped `.sql` file just created.

The corresponding `make restore-snapshot` target will run a `ddev import-db`
on the "latest" symlink, thus restoring the site to where it was when the most
recent `make snapshot` was taken.

By passing a name or short description to these targets, one can save and
restore multiple snapshots at different states or stages of development. The
[code providing this
feature](https://gitlab.com/consensus.enterprises/drumkit/-/blob/master/files/drupal-project/50_backup.mk)
largely manages these symlinks, creating and using them, as well as listing or
removing them using `make ls-snaps`, `make rm-snap` and `make rm-all-snaps`.

## Customizing

Once you have initialized a project with the Drumkit Drupal project template,
you can customize the Drumkit targets to suit the specifics of your project's
needs, by adding or modifying the files in your `[project]/drumkit/mk.d`
subdirectory.

For example, you may have extra steps that need to happen whenever you do `make
install`, so you add them to `drumkit/mk.d/40_install.mk`. Or perhaps you have
some common set of steps you run regularly, so you give them a dedicated target.

To add a `make migrate` target that would enable the relevant migrate-related
modules, and run the proper set of migrations in the correct order, add a file
like `drumkit/mk.d/60_migrate.mk`, with contenst like:

```
migrate:  ## Migrate content from old prod environment into local.
  $(ECHO) "$(YELLOW)Migrating Live content.$(RESET)"
  $(DRUSH) -y en migration_live
  @$(MAKE) migrate-users
  @$(MAKE) migrate-files
  @$(MAKE) migrate-nodes
  $(ECHO) "$(YELLOW)Finished migrating Live content.$(RESET)"

migrate-users: ## Migrate users and their data from old prod environment.
  $(DRUSH) migrate-import --group=users
  $(DRUSH) migrate-import --group=user_data

migrate-files: ## Migrate managed files, in batches of 1000
  $(DRUSH) migrate-import --limit=1000 --group=files
  $(DRUSH) migrate-import --limit=1000 --group=files
  $(DRUSH) migrate-import --limit=1000 --group=files

migrate-nodes: ## Migrate node content and translations
  $(DRUSH) migrate-import --group=node_original
  $(DRUSH) migrate-import --group=node_translated
```
