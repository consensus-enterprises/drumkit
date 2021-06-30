---
title: Structure of the Drumkit Project

---


Drumkit contains three kinds of make files in the `mk` directory:
[ note: we need to distinguish between `mk` and `.mk` in the documentation]
- Projects
- Tasks
- Tools

## Projects

You can use drumkit to initialize the following types of projects:
- Ansible (creates the following components)
	- Inventory
	- Groups
	- Hosts
- Packer 
- Drupal
- Hugo docs sites
- Aegir
- Openstack
- Aegir VPS


## Tasks

The "tasks" category is for ongoing building and maintenance tasks that have been automated with drumkit.

This includes:
- Running the docs server (`make docs-start` and `make docs-kill`)
- Managing git submodules
- Running drumkit tests (`make test-drumkit`)
- Running ansible playbooks

## Tools

This set of files is primarily for the installation of new tooling software. If it's a noun, it's probably in the "Tools" category. This is an evolving list, so check the `mk/tools` folder for the lastest options.

Some examples include:
- Hugo
- Gitlab-runner
- Lando (only on Linux - must be installed manually for OSX)
- Packer
- Terraform
