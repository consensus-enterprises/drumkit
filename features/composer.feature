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
    And I run "make clean"
    When I run "make composer"
    Then I should get:
      """
      Downloading the 1.0.0-beta1 release of Composer.
      Installing the 1.0.0-beta1 release of Composer.
      Composer version 1.0.0-beta1 2016-03-03 15:15:10
      """
    When I run "make composer"
    Then I should get:
      """
      make: Nothing to be done for `composer'.
      """
