Feature: Install Drush locally
  In order to develop on a local Drupal site
  As a Drupal developer
  I need to be able run Drush

  Scenario: Run 'make drush'
    When I run "ls"
    Then I should get:
      """
      Makefile
      """
