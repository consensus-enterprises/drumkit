@init @ansible-role @project @wip
Feature: Initialize Ansible role projects.
  In order to develop and test Ansible roles
  As a DevOps engineer
  I need to be able to initialize Ansible role projects

  Scenario: Initialize an Ansible role project.
    Given I bootstrap Drumkit
     When I run "make init-project-ansible-role role=myrole"
     Then I should get:
      """
      Initializing Drumkit Ansible role project
      Finished initializing Drumkit Ansible role project
      """
      And the following files should exist:
      """
      README.md
      defaults
      files
      handlers
      meta
      tasks
      templates
      tests/myrole
      tests/test.yml
      vars
      features/ansible-role-example.feature
      behat.yml
      """
      And the file "tests/test.yml" should contain:
      """
      ---
      - hosts: localhost
        become: yes
        become_user: root
      
        roles:
          - myrole
      """
     When I run "behat features/ansible-role-example.feature"
     Then I should get:
      """
      Feature: Running Ansible against localhost
      """
