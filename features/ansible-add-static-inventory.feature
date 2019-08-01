Feature: Generate Ansible static inventory
  In order to initialize an Ansible project on client-managed infrasructure
  As a DevOps engineer
  I want to specify a server, a group and an IP address, and have Ansible static inventory auto-generated for them.

   @ansible @ansible-add-static-inventory
   Scenario: Generate Ansible static inventory with arguments
    Given I bootstrap Drumkit
      And I run "git init"
      And I run "make ansible-add-static-inventory host=myhost group=mygroup ipaddress=10.0.0.1"
      Then I should get:
      """
      Generating Ansible static inventory file
      """
      Then the following files should exist:
      """
      inventory/inventory.yml
      """
      And the file "inventory/inventory.yml" should contain:
      """
      all:
        children:
          mygroup:
            hosts:
              myhost:
                ansible_host: 10.0.0.1
      """

   @ansible @ansible-add-static-inventory
   Scenario: Generate example static Ansible inventory by default
    Given I bootstrap Drumkit
      And I run "git init"
      And I run "make ansible-add-static-inventory"
      Then I should get:
      """
      Generating Ansible static inventory file
      Next, specify an IP address for example-host in inventory/inventory.yml
      """
      Then the following files should exist:
      """
      inventory/inventory.yml
      """
      And the file "inventory/inventory.yml" should contain:
      """
      all:
        children:
          example_group:
            hosts:
              example-host:
                ansible_host: IP_ADDRESS_GOES_HERE
      """
