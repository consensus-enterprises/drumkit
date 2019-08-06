Feature: Run Ansible host playbooks
  When working on an Ansible project
  As a DevOps engineer
  I want to be able to run Ansible host playbooks.

   @ansible @ansible-make-host
   Scenario: Run an Ansible host playbook.
    Given I bootstrap Drumkit
      And I run "make init-project-ansible"
      And I run "make -n playbooks/hosts/example-host.yml"
      Then I should not get:
      """
      Nothing to be done for
      """
      Then I should get:
      """
      ansible-playbook
      playbooks/hosts/example-host.yml
      """

   @ansible @ansible-make-hosts
   Scenario: Run all Ansible host playbooks.
    Given I bootstrap Drumkit
      And I run "make init-project-ansible"
      And I run "make ansible-add-host host=myhost"
      And I run "make -n hosts"
      Then I should not get:
      """
      Nothing to be done for
      """
      Then I should get:
      """
      ansible-playbook
      playbooks/hosts/example-host.yml
      playbooks/hosts/myhost.yml
      """
