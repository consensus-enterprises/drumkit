# Drumkit Ansible Template - README

This is a Drumkit Ansbile template project.

## Initial set-up

1. Set up repository:

```
$ git init
$ wget -O - https://gitlab.com/consensus.enterprises/drumkit/raw/master/scripts/install.sh | /bin/bash
$ make init-project-ansible
```

1. Now you'll have some useful defaults: 
  * A basic ansible.cfg
  * roles/ contains the Consensus admin-users and utils roles (which see).
  * playbooks/ has groups/ and hosts/ subdirectories, with examples in each. You'll need to edit these (and rename them to the names of your hosts and groups).
  * inventory/ contains an example static inventory file, which you'll need to update with real groups, hosts, and so on.
