@init @ansible @project
Feature: Initialize Ansible projects.
  In order to configure and manage systems with Ansible
  As a DevOps engineer
  I need to be able to initialize Ansible projects

  Scenario: Initialize an Ansible project.
    Given I bootstrap Drumkit
      And I run "git init"
      And I run "make init-project-ansible"
     Then I should get:
      """
      Initializing Drumkit Ansible project
	    Generating Ansible host config files
	    Generating Ansible group config files
      Finished initializing Drumkit Ansible project
      """
     Then the following files should exist:
      """
      roles/consensus.utils
      ansible.cfg
      README.md
      playbooks/hosts/example-host.yml
      playbooks/groups/example_group.yml
      inventory/host_vars/example-host.yml
      inventory/group_vars/example_group.yml
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
