---
title: GitLab CI Images
weight: 20
---

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
docker login registry.gitlab.com      # Authenticate to GitLab registry
make ci-images                        # Build and push CI images
```

Then use the resulting image in your `.gitlab-ci.yml` jobs:

```
image:
  name: registry.gitlab.com/hres/drupal-sites/submanager/submanager:latest
  entrypoint: [""] # We have to override the container entrypoint or else we end up in /bin/sh and `. d` doesn't work. See https://docs.gitlab.com/ee/ci/docker/using_docker_images.html#overriding-the-entrypoint-of-an-image
```

Drumkit includes a number of helpers to scaffold this setup for you. The key
pieces are:

* Drumkit targets for easy `make ci-images` setup
* GitLab image registry (to store your container images)
* Layered packer build scripts
* Helper scripts for packer to call when provisioning images

### Drumkit Targets

**TBD**: except for the top-level one, these should probably move up into drumkit

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

You should review the `scripts/packer/json/40-PROJECT.json` config and
`scripts/packer/scripts/PROJECT.sh` scripts and tailor them to your project,
then you can build and push your CI images like so:

```
docker login registry.gitlab.com
make ci-images
```

This will loop over all available `scripts/packer/json/*.json` files in order,
and run a `packer build` on each, to build and push the successive layers.
Typically this is:

* `10-bionic.json` - bare bones setup on to of Ubuntu Bionic 18.04
* `20-base.json` - basic Apt and other OS-level packages
* `30-php.json` - Apache / PHP
* `40-project.json` - Project-custom setup - typically building the codebase

Finally, you can use the resulting Docker image in your `.gitlab-ci.yml` jobs
like this:

```
image:
  name: registry.gitlab.com/hres/drupal-sites/submanager/submanager:latest
  entrypoint: [""] # We have to override the container entrypoint or else we end up in /bin/sh and `. d` doesn't work. See https://docs.gitlab.com/ee/ci/docker/using_docker_images.html#overriding-the-entrypoint-of-an-image
```

### GitLab Image Registry

Your GitLab project should have a Docker image registry enabled by default,
assuming your instance has the feature enabled.

While it is possible to automate authenticating to your image registry, the
simplest solution is to do a `docker login` before building the images below,
using your regular gitlab credentials. This just authenticates that you have
access to the project and permission to push container images:

```
docker login registry.gitlab.com
```

### Layered packer build scripts

The idea is to build up layers of Docker images, to build up your technology
stack. Each is built up based on the previous layer, but also easy to override
if you need to customize what a layer does.

For example, as Drupal developers, we typically want a LAMP stack, which
the core Drumkit targets provide:

* [`10-bionic.json`](https://gitlab.com/consensus.enterprises/drumkit/-/blob/master/scripts/packer/docker/10-bionic.json) - base Ubuntu 18.04 image (runs `apt.sh` and `purge-extra-packages.sh`)
* [`20-base.json`](https://gitlab.com/consensus.enterprises/drumkit/-/blob/master/scripts/packer/docker/20-base.json) - utilities (runs `utils.sh`)
* [`30-php.json`](https://gitlab.com/consensus.enterprises/drumkit/-/blob/master/scripts/packer/docker/30-php.json) - set up Apache, MySQL, PHP, it's libraries, and Composer (runs `php.sh`)
* `40-project.json` - project-level setup, usually just a `make build` of your project.

Example:

```
{
  "builders": [
    {
      "type": "docker",
      "image": "registry.gitlab.com/[GROUP]/[PROJECT]/php:latest",
      "commit": true
    }
  ],
  "provisioners": [
    {
      "type": "shell",
      "inline": "mkdir -p /var/www/[PROJECT]"
    },
    {
      "destination": "/var/www/[PROJECT]",
      "source": "./.clone/",
      "type": "file"
    },
    {
      "type": "shell",
      "scripts": [
        "scripts/packer/scripts/[PROJECT].sh",
        "scripts/packer/scripts/cleanup.sh"
      ]
    }
  ],
  "post-processors": [
    [
      {
        "type": "docker-tag",
        "repository": "registry.gitlab.com/[GROUP]/[PROJECT]/{{user `image_name`}}",
        "tag": "0.0.x"
      },
      {
        "type": "docker-tag",
        "repository": "registry.gitlab.com/[GROUP]/[PROJECT]/{{user `image_name`}}",
        "tag": "latest"
      },
      {
        "type": "docker-push"
      }
    ]
  ],
  "variables": {
    "image_name": "cv"
  }
}
```

### Helper scripts

Scripts:

* [`apt.sh`](https://gitlab.com/consensus.enterprises/drumkit/-/blob/master/scripts/packer/scripts/apt.sh) - configure Apt to install minimal packages, and other housekeeping
* [`purge-extra-packages.sh`](https://gitlab.com/consensus.enterprises/drumkit/-/blob/master/scripts/packer/scripts/purge-extra-packages.sh) - purge unnecessary packages
* [`php.sh`](https://gitlab.com/consensus.enterprises/drumkit/-/blob/master/scripts/packer/scripts/php.sh) - install Apache, PHP, and related modules/libraries
* [`cleanup.sh`](https://gitlab.com/consensus.enterprises/drumkit/-/blob/master/scripts/packer/scripts/cleanup.sh) - runs after each layer, to do an `apt-get autoremove &&
* `project.sh` - run project-specific build steps, to pre-load the CI image with needed artifacts

Example:

```
#!/bin/bash

# Steps for setting up CV inside a CI docker image at packer time.

# Run a composer install to pre-populate its cache, which should speed up the process in CI.
cd /var/www/[PROJECT]
. d
make build VERBOSE=1
```

#### .clone target (**TBD** Dan)

.clone target - for mysterious Packer reasons (that we are sure exist), we need
to clone the local project working dir into `.clone`, and have Packer work on
those.
