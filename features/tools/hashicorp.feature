Feature: Install Hashicorp tools locally
  In order to create various machine image formats
  As a developer
  I need to be able run packer

  Scenario: Remove packer
    Given I bootstrap drumkit
    When I run "make clean-packer"
    Then I should get:
      """
      Removing packer.
      """

  @slow
  Scenario: Install packer
    Given I bootstrap drumkit
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
      make: Nothing to be done for `packer'.
      """
