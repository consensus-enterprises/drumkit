Feature: Install Composer locally
  In order to install PHP applications
  As a developer
  I need to be able run Composer

  Scenario: Remove Composer
    Given I bootstrap drumkit
    When I run "make clean-composer"
    Then I should get:
      """
      Removing Composer.
      """

  @slow
  Scenario: Install Composer
    Given I bootstrap drumkit
    When I run "make composer"
    Then I should get:
      """
      Downloading the 1.4.2 release of Composer.
      Installing the 1.4.2 release of Composer.
      Composer version 1.4.2 2017-05-17 08:17:52
      """
    When I run "make composer"
    Then I should get:
      """
      Nothing to be done for 'composer'.
      """
