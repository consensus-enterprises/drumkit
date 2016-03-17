Feature: Install Drush locally
  In order to develop on a local Drupal site
  As a Drupal developer
  I need to be able run Drush

  Scenario: Remove Drush
    Given I bootstrap drumkit
    When I run "make clean-drush"
    Then I should get:
      """
      Removing Drush.
      """

  @slow
  Scenario: Run 'make drush'
    Given I bootstrap drumkit
    When I run "make clean"
    When I run "make drush"
    Then I should get:
      """
      Downloading the 8.0.5 release of Drush.
      Installing the 8.0.5 release of Drush.
       Drush Version   :  8.0.5
      """
    When I run "make drush"
    Then I should get:
      """
      make: Nothing to be done for `drush'.
      """
