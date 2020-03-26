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

Drumkit includes a number of helpers to scaffold this setup for you. The key
pieces are:

* GitLab image registry (to store your container images)
* Layered packer build scripts
* Helper scripts for packer to call when provisioning images
* Drumkit targets for easy `make ci-image` setup

### GitLab Image Registry

* **TBD**: your project needs some basic config to enable (and authenticate) the docker image registry.

* **TBD**: need to setup environment variables, or some other auth mechanism (ie.
  `docker login`) to push images.


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

* [`apt.sh`](https://gitlab.com/consensus.enterprises/drumkit/-/blob/master/scripts/packer/scripts/apt.sh) -
* [`purge-extra-packages.sh`](https://gitlab.com/consensus.enterprises/drumkit/-/blob/master/scripts/packer/scripts/purge-extra-packages.sh) -
* [`php.sh`](https://gitlab.com/consensus.enterprises/drumkit/-/blob/master/scripts/packer/scripts/php.sh) -
* [`cleanup.sh`](https://gitlab.com/consensus.enterprises/drumkit/-/blob/master/scripts/packer/scripts/cleanup.sh) - runs after each layer, to do an `apt-get autoremove &&
* `project.sh` - run project-specific build steps, to pre-load the CI image with needed artifacts

Example:

```
#!/bin/bash

# Steps for setting up CV inside a CI docker image at packer time.

# Run a composer install to pre-populate its cache, which should speed up the process in CI.
cd /var/www/project-codebase
. d
make build VERBOSE=1
```

### Drumkit Targets

In our top-level Makefile we create targets like this:

**TBD**: except for the top-level one, these should probably move up into drumkit

```
ci-image: php-image
        @echo "Building packer image for CI."
        @packer build scripts/packer/docker/40-[PROJECT].json

php-image: base-image
        @echo "Building packer PHP image."
        @packer build scripts/packer/docker/30-php.json

base-image: bionic-image
        @echo "Building base image."
        @packer build scripts/packer/docker/20-base.json

bionic-image: clone
        @echo "Building bionic image."
        @packer build scripts/packer/docker/10-bionic.json

```

#### .clone target (**TBD** Dan)

.clone target - for mysterious Packer reasons (that we are sure exist), we need
to clone the local project working dir into `.clone`, and have Packer work on
those.
