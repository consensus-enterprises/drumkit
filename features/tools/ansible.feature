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
      Installing Ansible.
        config file =
        configured module search path = Default w/o overrides
      Installing Ansible Doc.
      Installing Ansible Playbook.
      Installing Ansible Vault.
      Installing Ansible Galaxy.
      Installing Ansible Pull.
      """
    When I run "make ansible"
    Then I should get:
      """
      make: Nothing to be done for `ansible'.
      """
