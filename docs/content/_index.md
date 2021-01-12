---
title: Drumkit

---

Drumkit is a toolkit for developing Drupal sites, modules, themes and profiles.

## Quick Start

Drumkit is installed on a project-by-project basis, as a git submodule. To add `drumkit` to an existing Drupal project, run the following command:

```console
wget -O - https://drumk.it/installer | /bin/bash
```

For further details on installation procedures and options, see the [Install](install) page.

## Common Commands [None of these currently work]

Drumkit is built atop [GNU Make](https://www.gnu.org/software/make/), a ubiquitous build tool present on all Unixes. As such, all Drumkit commands must be run from the root of your project, and are prefaced by `make`.

* `make help` - Print a help message.
* `make install` - Install all tools.
* `make up` - Start a VM, in which a Drupal site will be installed and made available at http://localhost:8888.
* `make test` - Run tests.
* `make rebuild` - Destroy the current VM and re-provision a new one.

Drumkit comes with lots of other commands (GNU Make targets). For more details, see the [Usage](usage) page.
