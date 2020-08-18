@tasks @ci
Feature: Run CI
  In order to test a Drupal site
  As a developer
  I need to be able run Behat in CI

  Background:
    Given I bootstrap a clean drumkit environment

  @slow
  Scenario: Install behat when running CI, unless it is already installed.
    When I run "make clean-behat"
     And I run "make -n run-behat-ci"
    Then I should get:
      """
      make -s behat
      """
    When I run "make behat"
    And  I run "make -n run-behat-ci"
    Then I should not get:
      """
      make -s behat
      """
