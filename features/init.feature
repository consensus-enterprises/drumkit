Feature: Initialize various infrastructure projects
  In order to use drumkit's features
  As a DevOps engineer
  I need to be able to initialize infrastructure projects

# TODO: test running with static inventory a la HC

   @init @openstack @project
   Scenario: Initalize openstack cloud project
     Given I bootstrap Drumkit
       And I run "git init"
       And I run "make init-project-openstack"
      Then I should get:
       """
       Initializing Drumkit Openstack Infrastructure project
       """
      Then the following files should exist:
       """
       roles/consensus.admin-users
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
 
#   @init @aegirvps @project
#   Scenario: Initialize aegir VPS project
#     Given I bootstrap Drumkit
#       And I run "git init"
#       And I run "make init-project-aegir-vps"
#      Then I should get:
#       """
#       Initializing Drumkit Aegir VPS project
#       """
#      Then the following files should exist:
#       """
#       roles/consensus.admin-users
#       """
 
  @init @ansible @project
  Scenario: Initialize ansible project
    Given I bootstrap Drumkit
      And I run "git init"
      And I run "make init-project-ansible"
     Then I should get:
      """
      Initializing Drumkit Ansible project
      """
     Then the following files should exist:
      """
      roles/consensus.admin-users
      roles/consensus.utils
      ansible.cfg
      README.md
      inventory/example-inventory.yml
      playbooks/hosts/example-host.yml
      playbooks/groups/example-group.yml
      """
     Then I run "make"
      And I should get:
      """
        services 
           Ensure all services and applications are installed and configured on all groups and hosts.
        groups 
           Run all group playbooks.
        [playbooks/groups/GROUP_NAME.yml]
           Run the specified group playbook.
        hosts 
           Run all host playbooks.
        [playbooks/hosts/HOST_NAME.yml]
           Run the specified host playbook.
      """

  @init @aegir @project
  Scenario: Initialize aegir project with no infrastructure management
    Given I bootstrap Drumkit
      And I run "git init"
      And I run "make init-project-aegir"
     Then I should get:
      """
      Initializing Drumkit Aegir project
      """
     Then the following files should exist:
      """
      roles/consensus.aegir-policy
      roles/consensus.admin-users
      roles/consensus.aegir
      roles/consensus.aegir-skynet
      roles/consensus.utils
      roles/geerlingguy.composer
      roles/geerlingguy.drush
      roles/geerlingguy.git
      roles/geerlingguy.mysql
      roles/geerlingguy.php
      playbooks/groups/aegir.yml
      """
