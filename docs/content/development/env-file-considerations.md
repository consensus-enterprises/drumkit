---
title: .env file considerations

---

As Drumkit is a tool for scaffolding web projects and working with other tools, anyone who will be writing make targets for Drumkit will need to understand what kinds of things you can/cannot and should/should not do with the `.env` file.

## The Rules

In summary, the golden rules for `.env` files are:

1. A `.env` file must never be committed to a repo.
2. A `.env` file should never contain more than one line with a particular variable name.
3. Assume that the variables defined in the `.env` file are visible to all software and containers in that application.
4. Assume the project using Drumkit will define their own `.env` make target.

... these will be discussed in more detail below.

### Never commit a .env file

 1. The [12-factor app model, factor III, says to store configuration in environment variables](https://12factor.net/config) (env vars)
    1. Examples of configuration given in that spec include DB connection information (host, port, username, password, schema), and API keys.
    2. You can think of the `.env` file like Drupal's `settings.php` but for other apps.
2. In general, passwords, secret keys, etc. shouldn't be committed to a repo.
3. Even if your app stores the secrets separately, remember that non-secret configuration often varies between environments.
4. Even if the project you're working on isn't directly using `.env` to store config/secrets, other programs you or other developers use might automatically import variables from them and/or change their behaviour based on environment variables imported by other layers in the stack:
    1. [Acquia Cloud](https://docs.acquia.com/cloud-platform/develop/env-variable/)
    1. [Composer](https://getcomposer.org/doc/03-cli.md#environment-variables)
    1. [Ddev](https://ddev.readthedocs.io/en/stable/users/extend/customization-extendibility/)
    1. [Docker](https://docs.docker.com/compose/env-file/)
    1. [Drush](https://www.drush.org./latest/site-aliases/#environment-variables)
    1. [Lando](https://docs.lando.dev/config/env.html#environment-files)
    1. [platform.sh](https://docs.platform.sh/development/variables.html#environment-variables)
    1. [Pressflow](https://github.com/pressflow/7/blob/31effafc2fa7a65aad7880c9f740054eefd29c57/includes/bootstrap.inc#L764-L778) and [Pantheon-flavoured Drupal cores](https://github.com/pantheon-systems/drupal-integrations/blob/54be6ccd52ca10ae154e79a604201459c28341b4/assets/settings.pantheon.php#L94-L123)
    1. [Symfony](https://symfony.com/doc/current/configuration.html#config-env-vars)
    1. [Terminus](https://github.com/pantheon-systems/terminus#setting-default-user-site-environment-etc-and-dotenv)

Consequently, expect the `.env` file to not exist or be empty when your target is run.

### No lines with duplicate variable names

The `.env` file format doesn't have an official spec; the behaviour when two lines try to define the same variable differs based on the parser:

* shell-based parsers treat the .env file like a .bashrc / .profile file, i.e.: where later assignments overwrite the value set by earlier assignments
* similarly, the popular PHP parser, symfony/dotenv, and the popular Ruby parser, bkeepers/dotenv, also let the last definition take precedence because they store the collection of variables internally as [a hash](https://github.com/bkeepers/dotenv/blob/c237d6d6291c898d8affb290b510c7aac49aed71/lib/dotenv/parser.rb#L51)) (i.e. [PHP array](https://github.com/symfony/dotenv/blob/1ac423fcc9548709077f90aca26c733cdb7e6e5c/Dotenv.php#L255)
* contrarily, the popular JS parser, motdotla/dotenv (used in Lando, for example), [uses the first definition only](https://github.com/motdotla/dotenv/blob/27dfd3f034ce00b1daa72effbd91dd7788aced48/lib/main.js#L104-L108)

Consequently, blindly appending lines to the `.env` file (e.g.: with a shell script's `>>` pipe redirection operator) is very likely to lead to unexpected behaviour.

Note that [the `dotenv-linter/dotenv-linter` project](https://dotenv-linter.github.io) provides validation, fixing, and comparison tools for `.env` files.

### Assume variables defined in .env are visibile to all apps

Simply put, many platforms deploy them to all parts of the app (usually, all containers), e.g.: [Lando](https://docs.lando.dev/config/env.html#environment-files), [Platform.sh](https://docs.platform.sh/development/variables.html#environment-variables), [Acquia Cloud](https://docs.acquia.com/cloud-platform/develop/pipelines/yaml/#variables), etc.

Also note that some developers use [direnv](https://direnv.net) to automatically load variables into their current environment.

### Assume the project will define its own .env make target

It's reasonable to expect that a project will need its own way to compile its `.env` file to fit its particular stack of software, in the same way it's reasonable to expect that a project will need to define its own `build` and `install` steps to fit its particular stack of software.

Put another way, let a project define it's own `.env:` make target in `drumkit/mk.d/`; so in Drumkit itself, if you're writing make targets to add/modify a `.env` file, prefix the make target names appropriately so they don't collide.

## More reading

* [The .env file originally started as a way to define env vars into your shell at *NIX login](https://www.ibm.com/support/knowledgecenter/ssw_aix_72/osmanagement/env_file.html)
