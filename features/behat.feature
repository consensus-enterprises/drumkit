Feature: Install Behat locally
  In order to test a Drupal site
  As a developer
  I need to be able run Behat

  Scenario: Remove Behat
    Given I am in a temporary directory
    And I run "git init"
    And I execute "scripts/install.sh"
    When I run "make clean-behat"
    Then I should get:
      """
      Removing Behat.
      """

  @slow
  Scenario: Run 'make behat'
    Given I am in a temporary directory
    And I run "git init"
    And I execute "scripts/install.sh"
    And I run "make clean"
    When I run "make behat"
    Then I should get:
      """
      Creating source directory.
      Creating binary directory.
      Downloading the 1.0.0-beta1 release of Composer.
      Installing the 1.0.0-beta1 release of Composer.
      Composer version 1.0.0-beta1 2016-03-03 15:15:10
      Downloading Behat.
      Installing Behat.
      """
