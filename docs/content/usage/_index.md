---
title: Usage
weight: 10

---

GNU Make
--------

Most Drupal platform creation refers to Drush makefiles. Drumkit includes a set
of [GNU Make](https://www.gnu.org/software/make/)files. Familiarity with Make
will allow you to extend and override Drumkit's functionality. However, for
normal usage all you need to know is that all commands are prefaced by `make`,
which invokes GNU Make.


Projects
----


```console
$ make help-projects
init-project-aegir             Initialize a project for deploying Aegir with Ansible (application only, no infrastructure management).
init-project-aegirvps          Initialize a project to manage full-stack AegirVPS systems on Openstack. 
init-project-ansible           Initialize a project for working with Ansible.
init-project-hugo-docs         Initialize a hugo site
init-project-openstack         Initialize a project for provisioning cloud infrastructure on an OpenStack provider.
init-project-packer            Initialize a packer project.

```