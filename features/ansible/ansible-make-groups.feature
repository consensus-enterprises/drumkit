Feature: Run Ansible group playbooks
  When working on an Ansible project
  As a DevOps engineer
  I want to be able to run Ansible group playbooks.

   @ansible @ansible-make-group
   Scenario: Run an Ansible group playbook.
    Given I bootstrap Drumkit
      And I run "make init-project-ansible"
      And I run "make -n playbooks/groups/example_group.yml"
      Then I should not get:
      """
      Nothing to be done for
      """
      Then I should get:
      """
      ansible-playbook
      playbooks/groups/example_group.yml
      """

   @ansible @ansible-make-groups
   Scenario: Run all Ansible group playbooks.
    Given I bootstrap Drumkit
      And I run "make init-project-ansible"
      And I run "make ansible-add-group group=mygroup"
      And I run "make -n groups"
      Then I should not get:
      """
      Nothing to be done for
      """
      Then I should get:
      """
      ansible-playbook
      playbooks/groups/example_group.yml
      playbooks/groups/mygroup.yml
      """
