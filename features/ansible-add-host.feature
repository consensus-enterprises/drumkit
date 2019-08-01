Feature: Add an Ansible host
  In order to work on an Ansible project
  As a DevOps engineer
  I want to be able to generate Ansible config automatically for hosts.

   @ansible @ansible-add-host
   Scenario: Add an example Ansible host by default.
    Given I bootstrap Drumkit
      And I run "git init"
      And I run "make ansible-add-host"
      Then the following files should exist:
      """
      inventory/host_vars/example-host.yml
      playbooks/hosts/example-host.yml
      """
      And the file "inventory/host_vars/example-host.yml" should contain:
      """
      Host vars file generated by Drumkit; place variables that are specific to the `example-host` host here.
      """
      And the file "playbooks/hosts/example-host.yml" should contain:
      """
      - name: Host playbook for host 'example-host' generated by Drumkit.
        hosts: example-host
        become: true
        gather_facts: True
      """

   @ansible @ansible-add-host
   Scenario: Add an Ansible host that I specify.
    Given I bootstrap Drumkit
      And I run "git init"
      And I run "make ansible-add-host host=myhost"
      Then the following files should exist:
      """
      inventory/host_vars/myhost.yml
      playbooks/hosts/myhost.yml
      """
      And the file "inventory/host_vars/myhost.yml" should contain:
      """
      Host vars file generated by Drumkit; place variables that are specific to the `myhost` host here.
      """
      And the file "playbooks/hosts/myhost.yml" should contain:
      """
      - name: Host playbook for host 'myhost' generated by Drumkit.
        hosts: myhost
        become: true
        gather_facts: True
      """