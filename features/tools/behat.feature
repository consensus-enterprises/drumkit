@tools @behat
Feature: Install Behat locally
  In order to test a Drupal site
  As a developer
  I need to be able run Behat

  Background:
    Given I bootstrap a clean drumkit environment

  Scenario: Remove Behat
    When I run "make clean-behat"
    Then I should get:
      """
      Removing Behat.
      """

  @slow
  Scenario: Run 'make behat'
    When I run "make behat"
    Then I should get:
      """
      Downloading Behat.
      Installing Behat.
      """
    When I run "make behat"
    Then I should get:
      """
      Nothing to be done for 'behat'.
      """
