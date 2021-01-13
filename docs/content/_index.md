---
title: Drumkit

---

Drumkit is a toolkit for developing Drupal sites, modules, themes and profiles.

## Quick Start

Drumkit is installed on a project-by-project basis, as a git submodule. To add `drumkit` to an existing Drupal project, run the following command in the root directory:

```console
wget -O - https://drumk.it/installer | /bin/bash
```

For further details on installation procedures and options, see the [Install](install) page.

### Drumkit is self-documenting 

* `make help` - Print a list of available make targets with one-line description 

Note: This is not a comprehensive list of all targets in the library, but an overview of the ones that are intended to be called directly from the command line

To get more information on how the self-documentation features work, run `make selfdoc-howto`

## Common Commands

Drumkit is built atop [GNU Make](https://www.gnu.org/software/make/), a ubiquitous build tool present on all Unixes. As such, all Drumkit commands must be run from the root of your project, and are prefaced by `make`.

The primary use case for drumkit is spinning up and configuring new projects, including:
* packer images
* ansible roles
* drupal sites
* hugo document sites
* aegir instances

As such, there is a high-level target provided for each of these types of projects.

A list of the currently available project types is included in the `make help`. New projects are started with commands of the form `make init-project-[project type]`





Drumkit comes with lots of other commands (GNU Make targets). For more details, see the [Usage](usage) page.
