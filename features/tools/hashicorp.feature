@tools @packer
Feature: Install Hashicorp tools locally
  In order to create various machine image formats
  As a developer
  I need to be able run packer

  Background:
    Given I bootstrap a clean drumkit environment

  Scenario: Remove packer
    When I run "make clean-packer"
    Then I should get:
      """
      Removing packer.
      """

  @slow
  Scenario: Install packer
    When I run "make packer"
    Then I should get:
      """
      Downloading the
      Unzipping packer.
      Installing the
      release of packer.
      Packer v
      """
    When I run "make packer"
    Then I should get:
      """
      Nothing to be done for 'packer'.
      """

  @tools @terraform
  Scenario: Remove terraform
    When I run "make clean-terraform"
    Then I should get:
      """
      Removing terraform.
      """

  @slow
  Scenario: Install terraform
    When I run "make packer"
    Then I should get:
      """
      Downloading the
      Unzipping terraform.
      Installing the
      release of terraform.
      Terraform v
      """
    When I run "make terraform"
    Then I should get:
      """
      Nothing to be done for 'terraform'.
      """
