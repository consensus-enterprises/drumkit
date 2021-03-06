Feature: Add an Ansible group
  In order to work on an Ansible project
  As a DevOps engineer
  I want to be able to generate Ansible config automatically for groups.

   @ansible @ansible-add-group
   Scenario: Add an example Ansible group by default.
    Given I bootstrap Drumkit
      And I run "make ansible-add-group"
      Then the following files should exist:
      """
      inventory/group_vars/example_group.yml
      playbooks/groups/example_group.yml
      """
      And the file "inventory/group_vars/example_group.yml" should contain:
      """
      Group vars file generated by Drumkit; place variables that are specific to the `example_group` group here.
      """
      And the file "playbooks/groups/example_group.yml" should contain:
      """
      - name: Group playbook for group 'example_group' generated by Drumkit.
        hosts: example_group
        become: true
        gather_facts: True
      """

   @ansible @ansible-add-group
   Scenario: Add an Ansible group that I specify.
    Given I bootstrap Drumkit
      And I run "make ansible-add-group group=mygroup"
      Then the following files should exist:
      """
      inventory/group_vars/mygroup.yml
      playbooks/groups/mygroup.yml
      """
      And the file "inventory/group_vars/mygroup.yml" should contain:
      """
      Group vars file generated by Drumkit; place variables that are specific to the `mygroup` group here.
      """
      And the file "playbooks/groups/mygroup.yml" should contain:
      """
      - name: Group playbook for group 'mygroup' generated by Drumkit.
        hosts: mygroup
        become: true
        gather_facts: True
      """

   @ansible @ansible-clean-group
   Scenario: Clean an Ansible group that I specify.
    Given I bootstrap Drumkit
      And I run "make ansible-add-group group=mygroup"
      And I run "make ansible-clean-group group=mygroup"
      Then I should get:
      """
	    Cleaning up Ansible group config files for mygroup.
      """
      And the following files should not exist:
      """
      inventory/group_vars/mygroup.yml
      playbooks/groups/mygroup.yml
      """

   @ansible @ansible-clean-group
   Scenario: Cleaning a non-existent Ansible group is idempotent and does not cause an error.
    Given I bootstrap Drumkit
      And I run "make ansible-clean-group group=mygroup"
      Then I should get:
      """
	    Cleaning up Ansible group config files for mygroup.
      """
      And the following files should not exist:
      """
      inventory/group_vars/mygroup.yml
      playbooks/groups/mygroup.yml
      """

# TODO: test overriding the template
