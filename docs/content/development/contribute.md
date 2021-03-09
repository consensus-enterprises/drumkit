---
title: Contributing to Drumkit
weight: 30
---

Because Drumkit is intended to be installed and used as a submodule of other projects, the process of installing the it for developing _Drumkit itself_ (rather than the project it is being used for) has some particular requirements.

It still needs to be installed as a submodule, even if it is dropped into an empty git repo on your machine.

To bootstrap a clean installation of Drumkit, 

```
mkdir myproject
cd myproject
git init

wget -O - https://drumk.it/install-dev | /bin/bash
source d
```
**This installation will only work if you are a member of the `drumkit` project and have a public key on GitLab.** 

Otherwise you will need to fork the project and make pull requests from your fork of the repo.

### What happens

This will add drumkit as a submodule called `.mk` to the current git repo, then recursively clone the remote drumkit repo into a new `.mk` folder via SSH.

It generates a Makefile in the root folder that "includes" the GNUMakefile which is in the `.mk` folder 

The GNUMakefile then includes the makefiles contained below `mk`... that is, if you run `make` in the root directory, it will now be able to find all the targets in the folders inside `.mk/mk`)


Once that the `make` files have all been included, the script runs `make init-drumkit`, which creates a symlink to the `.mk/d` 

This in turn points to `.mk/scripts/bootstrap.sh`, which contains a collection of shell scripts whose sole purpose is to set environment variables necessary for Drumkit to run.

### The Main Conceit

Drumkit is designed to gather all the necessary binaries for a particular project into a single place, so that they don't need to be installed globally on the developer's machine. This allows projects to use different versions of the same tools, and maintains the ability to develop legacy systems with appropriate dependencies.

`source d` runs all the scripts in the `.mk/drumkit/bootstrap.d` folder, which adds `.local/` to your PATH variable. 

(This is, incidentally, why you have to run `source d` every time you open a new terminal in your project.)

At this point, you will be able to make changes to the files inside drumkit (below the `.mk` folder) and push them to the drumkit repo.

However, most of the impacts of using Drumkit occur at the root directory, so there is an additional layer of abstraction to consider. 
