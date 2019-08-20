@init @ansible-role @project @wip
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
      
        roles:
          - myrole
      """

  @slow
  Scenario: Initialize and test an Ansible role project.
    Given I bootstrap Drumkit
     And I run "make init-project-ansible-role role=myrole"
     When I run "make ansible-role-check"
     Then I should get:
     """
     Run the test playbook
     with --check
     PLAY [localhost]
     ok: [localhost]
     """
     When I run "make ansible-role-test"
     Then I should get:
     """
     Run the test playbook
     ok: [localhost]
     """

  # TODO: add nontrivial-test.yml
  @wip
  Scenario: Test Ansible role target idempotence.
    Given I bootstrap Drumkit
     And I run "make init-project-ansible-role role=myrole"
     When I run "make ansible-role-test ANSIBLE_TEST_PLAYBOOK=.mk/files/ansible-role/nontrivial-test.yml"
     Then I should get:
     """
     ok: [localhost]
     changed: [localhost]
     """
     When I run "make ansible-role-test ANSIBLE_TEST_PLAYBOOK=.mk/files/ansible-role/nontrivial-test.yml"
     Then I should not get:
     """
     changed: [localhost]
     """
