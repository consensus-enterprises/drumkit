@tools @ansible @ansible-galaxy
Feature: Install Ansible Galaxy locally
  In order to develop Ansible roles
  As a DevOps engineer
  I need to be able run Ansible Galaxy

  Background:
    Given I bootstrap a clean drumkit environment

  Scenario: Remove Ansible Galaxy
    When I run "make clean-ansible-galaxy"
    Then I should get:
      """
      Removing Ansible Galaxy.
      """

  @slow
  Scenario: Download and Install Ansible Galaxy
    When I run "make ansible-galaxy"
    Then I should get:
      """
      Installing Ansible Galaxy.
      """
    When I run "make ansible-galaxy"
    Then I should get:
      """
      Nothing to be done for 'ansible-galaxy'.
      """
    When I run "ansible-galaxy --version role"
