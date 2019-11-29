@tools @ansible
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
  Scenario: Download and Install Ansible
    When I run "make ansible"
    Then I should get:
      """
      Deploying Ansible config file.
      Installing Ansible.
      """
    When I run "make ansible"
    Then I should get:
      """
      Nothing to be done for 'ansible'.
      """
