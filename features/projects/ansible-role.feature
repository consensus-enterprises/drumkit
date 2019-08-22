@init @ansible-role @project
Feature: Initialize Ansible role projects.
  In order to develop and test Ansible roles
  As a DevOps engineer
  I need to be able to initialize Ansible role projects

  Background:
    Given I run "make ansible-role-test-cache"
      And I bootstrap Drumkit
      And I run "make link-ansible-role-test-cache"

  Scenario: Initialize an Ansible role project.
     When I run "make -n init-project-ansible-role role=myrole"
     Then I should get:
      """
      Initializing Drumkit Ansible role 'myrole'
      Finished initializing Drumkit Ansible role project
      """

  @slow @debug
  Scenario: Set up Ansible role project dependencies.
     When I run "unset DRUMKIT && . d && which ansible-galaxy"
     Then I should get:
     """
     /tmp/behat_cli
     .mk/.local/bin/ansible-galaxy
     """

  @debug
  Scenario: Set up an Ansible role project.
     When I run "unset DRUMKIT && . d && make setup-ansible-role role=myrole"
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
      
        roles:
          - myrole
      """

  @slow @debug
  Scenario: Initialize and test an Ansible role project.
    Given I run "unset DRUMKIT && . d && make init-project-ansible-role role=myrole"
     When I run "unset DRUMKIT && . d && make ansible-role-check"
     Then I should get:
     """
     Run the test playbook
     with --check
     PLAY [localhost]
     ok: [localhost]
     """
     When I run "unset DRUMKIT && . d && make ansible-role-test"
     Then I should get:
     """
     Run the test playbook
     ok: [localhost]
     """

  @slow @debug
  Scenario: Test Ansible role target idempotence.
    Given I run "rm -rf /tmp/drumkit-ansible-role-test"
      And the following files do not exist:
     """
     /tmp/drumkit-ansible-role-test
     """
      And I run "unset DRUMKIT && . d && make init-project-ansible-role role=myrole"
     When I run "unset DRUMKIT && . d && make ansible-role-test ANSIBLE_TEST_PLAYBOOK=.mk/files/ansible-role/nontrivial-test.yml"
     Then I should get:
     """
     ok: [localhost]
     changed: [localhost]
     """
     When I run "unset DRUMKIT && . d && make ansible-role-test ANSIBLE_TEST_PLAYBOOK=.mk/files/ansible-role/nontrivial-test.yml"
     Then I should not get:
     """
     changed: [localhost]
     """
     When I run "rmdir /tmp/drumkit-ansible-role-test"
     Then the following files should not exist:
     """
     /tmp/drumkit-ansible-role-test
     """
