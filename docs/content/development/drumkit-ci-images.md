---
title: Building Drumkit CI images
menutitle: Build CI images
---

## Introduction

We build and maintain custom [Container
images](https://gitlab.com/consensus.enterprises/drumkit/container_registry)
that we depend on in various Drupal/DDEV projects. To build these images, we
leverage Drumkit's own [CI image building feature](/usage/images/).

### Structure

The local set of images are a layered hierarchy:

* `ubuntu` is a custom build of a stock upstream image, [configuring Apt for automated runs and removing a bunch of cruft from the stock image](https://gitlab.com/consensus.enterprises/drumkit/-/blob/main/scripts/packer/scripts/apt.sh?ref_type=heads).
* `base` builds on `ubuntu` by adding a [few common utilities](https://gitlab.com/consensus.enterprises/drumkit/-/blob/main/scripts/packer/scripts/utils.sh?ref_type=heads) we always want installed.
* `docker` installs the [Docker system](https://gitlab.com/consensus.enterprises/drumkit/-/blob/main/scripts/packer/scripts/docker.sh?ref_type=heads) into the image.
* `ddev` finally installs [DDEV](https://gitlab.com/consensus.enterprises/drumkit/-/blob/main/scripts/packer/scripts/ddev.sh?ref_type=heads) at a specific version.

These layers each rely on each other, and assume the previous image has been pushed to the registry. This means that building them entirely locally can be tricky.

## Setup

In order to *push* the Drumkit images, you will need to have credentials to
access the Gitlab container registry.

### Generate Personal Access Token

[Create a Personal Access Token](https://gitlab.com/-/user_settings/personal_access_tokens) that has the folowing permissions:

* `READ REGISTRY`
* `WRITE REGISTRY`
* `API`
* `READ REPOSITORY`

Use the generated Token as the value of the `CONTAINER_REGISTRY_PASSWORD` variable below.

### Create `.env` files

Clone the Drumkit code repository into a local environment, and then configure
a `.env` file with your credentials to push to the Gitlab Container Registry.
You can copy the [`.env.tmpl`](https://gitlab.com/consensus.enterprises/drumkit/-/blob/main/.env.tmpl) and modify the `CONTAINER_REGISTRY_USERNAME`
and `CONTAINER_REGISTRY_PASSWORD` variables.

```
CONTAINER_REGISTRY_URL=registry.gitlab.com/consensus.enterprises/drumkit
UBUNTU_VERSION=24.04
UBUNTU_CODENAME=noble
DDEV_VERSION=v1.25.1
CONTAINER_REGISTRY_USERNAME=<gitlab username>
CONTAINER_REGISTRY_PASSWORD=<personal access token>
```

## Build CI images

```
source d # This reads your `.env` into the current shell environment
make ci-images
```

### Building individual images

To build a specific image (one of `ubuntu`, `base`, `docker`, or `ddev`), you
can target the docker image like so:

```
source d
make docker/ddev # Calls make ci-image with variables to build the Docker image
```

### Building locally

If you want to test a build without pushing it, you can remove the
**`docker-push`** Post-processor in the [Packer JSON
file](https://gitlab.com/consensus.enterprises/drumkit/-/blob/main/scripts/packer/docker)
(`scripts/packer/docker/*.json`) for the image in question.

For example, in
[ddev.json](https://gitlab.com/consensus.enterprises/drumkit/-/blob/main/scripts/packer/docker/ddev.json?ref_type=heads#L24),
remove the following stanza:

```
{
	"type": "docker-push",
	"login": "true",
	"login_server": "{{user `repo_url`}}",
	"login_username": "{{user `login_username`}}",
	"login_password": "{{user `login_password`}}"
}
```

This will allow you to build a particular image locally, but only if you have
already pushed the lower [layers](#structure) of the structure. For example, to
build the `docker` image locally, I'd need to have built and pushed the
`ubuntu` and `base` images with the same version tags to the container
registry, since the Packer build files will pull them from the remote (even if
you've just built them locally).

### Building a specific OS or DDEV version

You can specify custom versions in your `.env` file, or you can provide them on
the command line:

```
source d
make ci-images UBUNTU_VERSION=20.04 UBUNTU_CODENAME=focal DDEV_VERSION=v1.22.6
```

This also works for building individual images eg. `make docker/ddev`

**NB** The `DDEV_VERSION` variable *must* have the `v` prefix or the download will fail.

