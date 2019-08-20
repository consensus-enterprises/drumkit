@tools
Feature: Install Drush locally
  In order to develop on a local Drupal site
  As a Drupal developer
  I need to be able run Drush

  Background:
    Given I bootstrap a clean drumkit environment

  Scenario: Remove Drush
    When I run "make clean-drush"
    Then I should get:
      """
      Removing Drush.
      """

  @slow
  Scenario: Run 'make drush'
    When I run "make drush"
    Then I should get:
      """
      Downloading the
      Installing the
			release of Drush.
       Drush Version   :
      """
    When I run "make drush"
    Then I should get:
      """
      Nothing to be done for 'drush'.
      """
