Feature: Install Drush locally
  In order to develop on a local Drupal site
  As a Drupal developer
  I need to be able run Drush

  Scenario: Run 'make drush'
    Given I run "make clean-drush"
    When I run "make drush"
    Then I should get:
      """
      Downloading the 8.0.5 release of Drush.
      Installing the 8.0.5 release of Drush.
       Drush Version   :  8.0.5 
      """
