---
title: GitLab CI Images
weight: 20
---

## Drumkit published DDEV CI Docker images

The Drumkit project publishes a set of Docker images which are intended to be
used in a GitLab CI environment, and primarily targeted at our Drupal or other
DDEV projects, so that CI pipelines can mirror our development environment as
closely as possible.

These images are published in our GitLab project [Drumkit container
registry](https://gitlab.com/consensus.enterprises/drumkit/container_registry).
See [Building Drumkit CI images](/development/drumkit-ci-images) for more
details.

### Using Drumkit CI images

To make use of the Drumkit DDEV CI projects, you can incorporate the image into
your `.gitlab-ci.yml` like so:

```
image:
  name: registry.gitlab.com/consensus.enterprises/drumkit/ddev:24.04-1.24.6
  entrypoint: [""] # We have to override the container entrypoint or else we end up in /bin/sh and `. d` doesn't work. See https://docs.gitlab.com/ee/ci/docker/using_docker_images.html#overriding-the-entrypoint-of-an-image
```

In many projects, this is sufficient to make your CI environment match your
local. We have found this to be invaluable, especially in Drupal projects that
use Selenium and Chromedriver containers, to have our test pipelines behave
exactly the same as they do locally. This comes with some overhead in starting
up the CI containers, but it's worth it in time saved troubleshooting flaky CI
pipelines.

Some projects need a more customized set of images, in which case we can expand
on the published Drumkit DDEV images and use the technique below to build our
own Project-customized container images. Drumkit will initialize Packer build
files into your project to mirror the ones built by Drumkit, after which you
can tailor them as needed.

The [Rugged project `build/packer/docker`](https://gitlab.com/rugged/rugged/-/tree/main/build/packer/docker)
scripts are an advanced example of this technique, composing a set of "worker"
images individually customized for their role in the system.


## Building Docker Images for GitLab CI

We have found it valuable to build project-specific Docker images, using
[Packer](https://packer.io), and using these to drive our CI process. The key
reason for this is it allows us to prime the CI image with exactly the pieces
our project needs, so that each CI pipeline doesn't need to set everything up
from scratch.

### TL;DR

```
# In a Drumkit-enabled project, do:
make init-project-packer              # Initialize packer scripts
[add GitLab personal access token to `.env`]
make ci-images                        # Build and push CI images
```

Then use the resulting image in your `.gitlab-ci.yml` jobs:

```
image:
  name: registry.gitlab.com/my-org/my-project/my-project:0.0.x
  entrypoint: [""] # We have to override the container entrypoint or else we end up in /bin/sh and `. d` doesn't work. See https://docs.gitlab.com/ee/ci/docker/using_docker_images.html#overriding-the-entrypoint-of-an-image
```

Drumkit includes a number of helpers to scaffold this setup for you. The key
pieces are:

* Drumkit targets for easy `make ci-images` setup
* GitLab image registry (to store your container images)
* Layered packer build scripts
* Helper scripts for packer to call when provisioning images

### Drumkit Targets

Drumkit has a project init target that will bootstrap the Packer-driven build
scripts described below. Here's how to use it:

```
# If you haven't already, install and initialize Drumkit
wget -O - https://drumk.it/installer
. d

# Then initialize packer scripts in your project:
make init-project-packer
```

This will prompt you for the name of your project, and a Docker image registry URL, which for
GitLab will look something like: `registry.gitlab.com/GROUP/PROJECT`.

These 2 values will be used to render a couple of templates, and the rest of
the boilerplate Packer `.json` config files and associated `.sh` provisioning
scripts for CI images copied into place in your project.

You should review the `scripts/packer/json/PROJECT.json` config and
`scripts/packer/scripts/PROJECT.sh` scripts and tailor them to your project.

Finally, you'll need to provide GitLab credentials via environment variables
for Packer to be able to login and push your images to the container registry
for your project. Drumkit provides a `.env.tmpl` file for this purpose, as well
as a `drumkit/bootstrap.d/01_environment.sh` bootstrap script when you run
`init-packer-project`.

Copy the `.env.tmpl` file to `.env` and then edit the file to replace the
`CONTAINER_REGISTRY_USERNAME` and `CONTAINER_REGISTRY_PASSWORD` values with
real ones. It is **highly recommended** to generate a [Personal Access
Token](https://gitlab.com/-/user_settings/personal_access_tokens) to use for
the password here.


With a `.env` file in place, build and push your CI images like so:

```
undrumkit && source d
make ci-images
```

This will loop over all available `scripts/packer/json/*.json` files in order,
and run a `packer build` on each, to build and push the successive layers.
Typically this is:

* `ubuntu.json` - Ubuntu with basic Apt and other OS-level packages
* `base.json` - Apache / PHP
* `docker.json` - Docker
* `ddev.json` - DDEV
* `PROJECT.json` - Project-custom setup - typically building the codebase

Finally, you can use the resulting Docker image in your `.gitlab-ci.yml` jobs
like this:

```
image:
  name: registry.gitlab.com/my-org/my-project/[project-name]:0.0.x
  entrypoint: [""] # We have to override the container entrypoint or else we end up in /bin/sh and `. d` doesn't work. See https://docs.gitlab.com/ee/ci/docker/using_docker_images.html#overriding-the-entrypoint-of-an-image
```

### GitLab Image Registry

Your GitLab project should have a Docker image registry enabled by default,
assuming your instance has the feature enabled.

### Layered packer build scripts

The idea is to build up layers of Docker images, to build up your technology
stack. Each is built up based on the previous layer, but also easy to override
if you need to customize what a layer does.

For example, as Drupal developers, we typically want a LAMP stack, which
the core Drumkit targets provide:

* [`ubuntu.json`](https://gitlab.com/consensus.enterprises/drumkit/-/blob/master/files/packer/json/ubuntu.json) - Ubuntu image (runs `apt.sh` and `purge-extra-packages.sh`)
* [`base.json`](https://gitlab.com/consensus.enterprises/drumkit/-/blob/master/files/packer/json/base.json) - utilities (runs `utils.sh`)
* [`ddev.json`](https://gitlab.com/consensus.enterprises/drumkit/-/blob/master/files/packer/json/docker.json) - install Docker
* [`ddev.json`](https://gitlab.com/consensus.enterprises/drumkit/-/blob/master/files/packer/json/ddev.json) - install DDEV
* [`project.json`](https://gitlab.com/consensus.enterprises/drumkit/-/blob/master/files/packer/project.json) - project-level setup, usually just a `make build` of your project.

### Helper scripts

Scripts:

* [`apt.sh`](https://gitlab.com/consensus.enterprises/drumkit/-/blob/main/scripts/packer/scripts/apt.sh) - configure Apt to install minimal packages, and other housekeeping
* [`cleanup.sh`](https://gitlab.com/consensus.enterprises/drumkit/-/blob/main/scripts/packer/scripts/cleanup.sh)  - runs after each layer, to do an `apt-get autoremove &&
* [`ddev.sh`](https://gitlab.com/consensus.enterprises/drumkit/-/blob/main/scripts/packer/scripts/ddev.sh) - install [DDEV](https://ddev.com)
* [`docker.sh`](https://gitlab.com/consensus.enterprises/drumkit/-/blob/main/scripts/packer/scripts/docker.sh) - install [Docker](https://docker.com)
* [`php.sh`](https://gitlab.com/consensus.enterprises/drumkit/-/blob/main/scripts/packer/scripts/php.sh) - install Apache, MySQL, PHP, and related modules/libraries plus Composer
* [`purge-extra-packages.sh`](https://gitlab.com/consensus.enterprises/drumkit/-/blob/main/scripts/packer/scripts/purge-extra-packages.sh) - Remove unnecessary packages
* [`utils.sh`](https://gitlab.com/consensus.enterprises/drumkit/-/blob/main/scripts/packer/scripts/utils.sh) - Install some standard utility packages
* [`project.sh.tmpl`](https://gitlab.com/consensus.enterprises/drumkit/-/blob/main/files/packer/project.sh.tmpl) - Template for project-custom provisioning script
