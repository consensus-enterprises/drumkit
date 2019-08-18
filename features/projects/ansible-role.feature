@init @ansible-role @project
Feature: Initialize Ansible role projects.
  In order to develop and test Ansible roles
  As a DevOps engineer
  I need to be able to initialize Ansible role projects

  Scenario: Initialize an Ansible role project.
    Given I bootstrap Drumkit
     When I run "make -n init-project-ansible-role role=myrole"
     Then I should get:
      """
      Initializing Drumkit Ansible role 'myrole'
      Finished initializing Drumkit Ansible role project
      """

  @debug @slow
  Scenario: Set up an Ansible role project.
    Given I bootstrap Drumkit
     When I run "make setup-ansible-role role=myrole"
     Then the following files should exist:
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
     # Use a sub-behat to confirm the example test passes, ansible itself still works the way we expect, etc.:
     When I run "behat features/ansible-role-example.feature"
     Then I should get:
      """
      Feature: Running Ansible against localhost
      """
