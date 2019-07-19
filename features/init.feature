@openstack @init
Feature: Initialize an openstack infrastructure project
  In order to use drumkit's features
  As a DevOps engineer
  I need to be able to initialize a new openstack infrastructure project

  Scenario: 
    Given I bootstrap Drumkit
      And I run "git init"
      And I run "make init-infra-openstack"
     Then I should get:
      """
      Initializing Drumkit Openstack Infrastructure project
      """
      Then the following files should exist:
      """
      roles/consensus.admin-users
      roles/consensus.aegir-policy
      roles/consensus.utils
      roles/consensus.aegir
      roles/consensus.cloud-openstack
      roles/geerlingguy.composer
      roles/geerlingguy.git
      roles/geerlingguy.nginx
      roles/geerlingguy.apache
      roles/geerlingguy.drush
      roles/geerlingguy.mysql
      roles/geerlingguy.php
      playbooks/infra.yml
      playbooks/host_vars/localhost.yml
      inventory/openstack.yml
      inventory/openstack_inventory.py
      """
     Then I run "make"
      And I should get:
      """
  inventory 
     List cloud inventory.
  facts
     Show all available cloud resources.
  flavors 
     Show all available VM flavors (sizes).
  images 
     Show all available OS images.
  infra
     Ensure all cloud resources exist and are provisioned/configured.
      """
