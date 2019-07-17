@openstack @init
Feature: Initialize an openstack infrastructure project
  In order to use drumkit's features
  As a DevOps engineer
  I need to be able to initialize a new openstack infrastructure project

  @debug
  Scenario: 
    Given I am in a temporary directory
      When I run "git init"
      And I execute "scripts/install.sh"
      And I bootstrap Drumkit
      And I run "make init-infra-openstack"
     Then I should get:
      """
      Initializing Drumkit Openstack Infrastructure project
      """
      Then the following files should exist:
      """
      ansible.cfg
      behat.yml
      features/testing.feature
      roles/consensus.cloud-openstack
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
