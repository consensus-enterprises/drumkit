@ansible-role @example
Feature: Running Ansible against localhost
  In order to run Ansible tests inside CI
  As a developer
  I need to be able to run Ansible test playbooks against localhost

# Example ansible role tests. We've left @debug turned on so you can see what
# we're doing.  These scenarios will pass as long as you have a valid playbook
# in tests/test.yml that runs against localhost.

  @debug
  Scenario: Run Ansible test playbook with --check
     When I run "make ansible-role-check"
     Then I should get:
     """
     Run the test playbook
     with --check
     PLAY [localhost]
     ok: [localhost]
     """
  @debug
  Scenario: Run Ansible test playbook test/test.yml against localhost
     When I run "make ansible-role-test"
     Then I should get:
     """
     Run the test playbook
     ok: [localhost]
     """
     # Test idempotence:
     When I run "make ansible-role-test"
     Then I should get:
     """
     ok: [localhost]
     """
     And I should not get:
     """
     changed: [localhost]
     """
