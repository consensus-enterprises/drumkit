@tools @ansible-suite
Feature: Install Ansible and related tools locally
  In order to automate infrastructure deployment
  As a DevOps engineer
  I need to be able run Ansible

  Background:
    Given I bootstrap a clean drumkit environment

  Scenario: Remove Ansible
    When I run "make clean-ansible"
    Then I should get:
      """
      Removing Ansible.
      Removing Ansible Doc.
      Removing Ansible Galaxy.
      Removing Ansible Inventory.
      Removing Ansible Playbook.
      Removing Ansible Pull.
      Removing Ansible Vault.
      """

  @slow
  Scenario: Download and install Ansible and related tools.
    When I run "make ansible-suite"
    Then I should get:
      """
      Deploying Ansible config file.
      Installing Ansible.
      Installing Ansible Doc.
      Installing Ansible Galaxy.
      Installing Ansible Inventory.
      Installing Ansible Playbook.
      Installing Ansible Pull.
      Installing Ansible Vault.
      """
    When I run "make ansible-suite"
    Then I should get:
      """
      Nothing to be done for 'ansible-suite'.
      """
