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

Lando is a development wrapper around docker, designed to allow you to rapidly spin up local development environments. To use drumkit this way, you need to already have lando and docker installed. (See the [Lando website](https://lando.dev) for instructions.)

**NB** As of Drupal 8.8.0, this [composer template is
deprecated](https://www.drupal.org/docs/develop/using-composer/using-composer-to-install-drupal-and-manage-dependencies) in favour of
[`drupal/recommended-project`](https://github.com/drupal/recommended-project).
Drumkit will shortly update this and/or make the composer template configurable
with sane defaults.

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
and Lando. [Wait... if you don't have lando and docker, what happens?]

#### On Linux
If any packages are missing you may be prompted by `sudo` for your
user password so `apt` can install them. 

#### On a Mac
You may need to manually install dependencies using `brew install {package}`.

Then it will call the `composer
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

## Development Workflows

Once you have a site instantiated and you begin working on it, there are some
Drumkit targets that are available to you immediately, such as:

1. `make clean-build` - wipe out your composer.json-installs trees under `vendor/` and `web/`
1. `make devtools` - install a set of development extensions (devel, field_ui, views_ui, etc.)
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

The corresponding `make restore-snapshot` target will run a `lando db-import`
on the "latest" symlink, thus restoring the site to where it was when the most
recent `make snapshot` was taken.

By passing a name or short description to these targets, one can save and
restore multiple snapshots at different states or stages of development. The
[code providing this
feature](https://gitlab.com/consensus.enterprises/drumkit/-/blob/master/files/drupal8/50_backup.mk)
largely manages these symlinks, creating and using them, as well as listing or
removing them using `make ls-snaps`, `make rm-snap` and `make rm-all-snaps`.

## Customizing

Once you have initialized a project with the Drumkit Drupal 8 project template,
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
  @$(ECHO) "$(YELLOW)Migrating Live content.$(RESET)"
  $(DRUSH) -y en migration_live
  @$(MAKE) migrate-users
  @$(MAKE) migrate-files
  @$(MAKE) migrate-nodes
  @$(ECHO) "$(YELLOW)Finished migrating Live content.$(RESET)"

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
