@init @openstack @project
Feature: Initialize OpenStack cloud projects.
  In order to provision OpenStack cloud infrastructure
  As a DevOps engineer
  I need to be able to initialize OpenStack infrastructure projects

  # TODO: test running with static inventory a la HC

   Scenario: Initialize an OpenStack cloud project.
     Given I bootstrap Drumkit
      When I run "make init-project-openstack"
      Then I should get:
       """
       Initializing Drumkit OpenStack infrastructure project
       Setting up consensus.cloud-openstack.
       Finished initializing Drumkit OpenStack infrastructure project
       """
       And the following files should exist:
       """
       roles/consensus.cloud-openstack
       inventory/openstack_inventory.py
       inventory/openstack.yml
       """
       And the file "ansible.cfg" should contain:
       """
       inventory = inventory/openstack_inventory.py
       """
      Then I run "make"
       And I should get:
       """
       flavors
          Show all available VM flavors (sizes).
       images
          Show all available OS images.
       infra
          Ensure all cloud resources exist and are provisioned/configured.
       """
