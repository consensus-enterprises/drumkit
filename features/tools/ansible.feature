Feature: Install Ansible and related tools locally
  In order to automate infrastructure deployment 
  As a DevOps engineer
  I need to be able run Ansible

  Scenario: Remove Ansible
    Given I bootstrap drumkit
    When I run "make clean-ansible"
    Then I should get:
      """
      Removing Ansible bootstrap script.
      Removing Ansible Playbook.
      Removing Ansible Vault.
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
      Deploying Ansible bootstrap script.
      Installing Ansible.
      Installing Ansible Doc.
      Installing Ansible Galaxy.
      Installing Ansible Inventory.
      Installing Ansible Playbook.
      Installing Ansible Pull.
      Installing Ansible Vault.
      """
    When I run "make ansible"
    Then I should get:
      """
      Nothing to be done for 'ansible'.
      """
