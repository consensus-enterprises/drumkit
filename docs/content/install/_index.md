---
title: Installation
weight: 1
draft: true
---

One-liner
---------

```console
wget -O - https://drumk.it/installer | /bin/bash
```

Install Tools
-------------

Sample installation commands:

```console

$ make composer
  Install Composer.
$ make composer COMPOSER_REL=1.0.0-beta1
  Install the 1.0.0-beta1 release of Composer.
$ make drush
  Install Drush.
$ make drush DRUSH_REL=8.0.5
  Install the 8.0.5 release of Drush.
$ make behat
  Install Behat.
$ make selenium
  Install Selenium.
```

The tools are installed locally in `.mk/.local/`. The idea here is to isolate
them from your local system setup. This should make it easier when working as a
team, since you'll all be using the same suite of local tools.

To use these locally installed tools, run:

```console
$ .mk/scripts/hacking.sh
```

This will (temporarily) add the local tools directory to your PATH, taking
priority over you your normal system installed tools.

