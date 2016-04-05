Feature: Install Ansible and related tools locally
  In order to automate infrastructure deployment 
  As a DevOps engineer
  I need to be able run Ansible

  Scenario: Remove Ansible
    Given I bootstrap drumkit
    When I run "make clean-ansible"
    Then I should get:
      """
      Removing Ansible Playbook.
      Removing Ansible Vault.
      Removing Ansible Console.
      Removing Ansible Galaxy.
      Removing Ansible Pull.
      Removing Ansible Doc.
      Removing Ansible. 
      """

  @slow
  Scenario: Download and Install Ansible
    Given I bootstrap drumkit
    When I run "make ansible"
    Then I should get:
      """
      Submodule 'lib/ansible/modules/core' (https://github.com/ansible/ansible-modules-core) registered for path 'lib/ansible/modules/core'
      Submodule 'lib/ansible/modules/extras' (https://github.com/ansible/ansible-modules-extras) registered for path 'lib/ansible/modules/extras'
      Submodule path 'lib/ansible/modules/core': checked out
      Submodule path 'lib/ansible/modules/extras': checked out
      Installing Ansible.
      ansible 2.0.1.0
        config file = 
        configured module search path = Default w/o overrides
      Installing Ansible Doc.
      Installing Ansible Playbook.
      Installing Ansible Vault.
      Installing Ansible Console.
      Installing Ansible Galaxy.
      Installing Ansible Pull.
      """
    When I run "make ansible"
    Then I should get:
      """
      make: Nothing to be done for `ansible'.
      """
