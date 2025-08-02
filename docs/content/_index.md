---
title: Drumkit

---
# What is Drumkit

Drumkit is a collection of scripts and templates designed to standardize and integrate some of the most frequent tasks we encounter.

It includes the abilty to: 
- Initialize a new [Drupal](https://en.wikipedia.org/wiki/Drupal) project on [DDEV](https://ddev.com)
- Initialize and publish a collection of [Packer](https://www.packer.io/) images for use in [CI](https://en.wikipedia.org/wiki/Continuous_integration) deployment
- Initialize and run a documentation site for the project using the [Hugo](http://gohugo.io/) static site generator
- Install gitlab-runner locally for testing of [Gitlab CI](https://docs.gitlab.com/ee/ci/) pipelines before pushing changes
- Integrate with [Ansible](https://en.wikipedia.org/wiki/Ansible_(software)) and [Aegir](https://www.aegirproject.org/) for provisioning and deployment to production systems


## Quick Start

Drumkit is installed on a project-by-project basis, as a git submodule. 

To add `drumkit` to an existing Drupal project, run the following command *in the root directory* of the project:

```console
wget -O - https://drumk.it/installer | /bin/bash
```

### Drumkit is self-documenting 

* `make help` - Print a list of available make targets with one-line description 

Note: This is not a comprehensive list of all targets in the library, but an overview of the ones that are intended to be called directly from the command line

## Common Commands

Drumkit is built atop [GNU Make](https://www.gnu.org/software/make/), a ubiquitous build tool present on all Unixes. As such, all Drumkit commands must be run from the root of your project, and are prefaced by `make`.

The primary use case for drumkit is spinning up and configuring new projects, including:
* packer images
* ansible roles
* drupal sites
* hugo document sites
* aegir instances

There is a high-level target provided for each of these types of projects.

A list of the currently available project types is included in the `make help`. 

New projects are started with commands of the form `make init-project-[project type]`
