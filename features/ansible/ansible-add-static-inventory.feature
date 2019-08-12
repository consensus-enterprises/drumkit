Feature: Generate Ansible static inventory
  In order to initialize an Ansible project on client-managed infrasructure
  As a DevOps engineer
  I want to specify a server, a group and an IP address, and have Ansible static inventory auto-generated for them.

   @ansible @ansible-add-static-inventory
   Scenario: Generate Ansible static inventory with arguments
    Given I bootstrap Drumkit
      And I run "make ansible-add-static-inventory host=myhost group=mygroup ipaddress=10.0.0.1 environment=staging"
      Then I should get:
      """
      Generating Ansible static inventory file
      """
      Then the following files should exist:
      """
      inventory/staging.yml
      """
      And the file "inventory/staging.yml" should contain:
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
      And I run "make ansible-add-static-inventory"
      Then I should get:
      """
      Generating Ansible static inventory file
      Next, specify an IP address for example-host in inventory/default.yml
      """
      Then the following files should exist:
      """
      inventory/default.yml
      """
      And the file "inventory/default.yml" should contain:
      """
      all:
        children:
          example_group:
            hosts:
              example-host:
                ansible_host: IP_ADDRESS_GOES_HERE
      """

   @ansible @ansible-clean-static-inventory
   Scenario: Clean up Ansible inventory.
    Given I bootstrap Drumkit
      And I run "make ansible-add-static-inventory"
      And I run "make ansible-clean-static-inventory"
      Then I should get:
      """
	    Cleaning up Ansible static inventory file.
      """
      And the following files should not exist:
      """
      inventory/default.yml
      """

   @ansible @ansible-clean-static-inventory
   Scenario: Cleaning non-existent Ansible inventory is idempotent and does not cause an error.
    Given I bootstrap Drumkit
      And I run "make ansible-clean-static-inventory"
      Then I should get:
      """
	    Cleaning up Ansible static inventory file.
      """
      And the following files should not exist:
      """
      inventory/default.yml
      """

# TODO: test overriding the template
