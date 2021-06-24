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

wget -O - https://drumk.it/installer | /bin/bash
source d
```
**If you are a member of the `drumkit` project and have a public key on GitLab, you can set up your project to push directly to the remote following the ensuing instructions. Otherwise you will need to fork the project and make pull requests from your fork of the repo.** 

Because we have a hard requirement for 2FA in this project, you cannot push changes without setting up SSH. *However*, the CI pipeline requires the submodule URL to be specified using https, or it would require an SSH key pair to be available on the image.

*Once you have installed drumkit in your project directory*
```
cd .mk
git config url."git@gitlab.com:".pushInsteadOf https://gitlab.com/
git remote -v
```

At this point, you should see that the origin is using `https` for `fetch`, and `ssh` for `push`. This is now properly configured for developing and pushing changes to `drumkit` itself, not just the surrounding project.

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

#### Common points of failure

When [testing](testing), for example, you need to remain aware of whether you are calling certain things (behat features, for example) from the project directory or from the `.mk` directory. Additionally, you need to keep the submodule and the project in sync. 

If you make changes to the `.mk` directory and then commit them in the containing project, you must push the `.mk` branch before pushing changes to the project, or the CI process is likely to fail, being unable to retrieve the correct commit of the Drumkit project.



