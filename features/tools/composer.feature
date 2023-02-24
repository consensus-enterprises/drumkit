@tools @composer
Feature: Install Composer locally
  In order to install PHP applications
  As a developer
  I need to be able run Composer

  Background:
    Given I bootstrap a clean Drumkit environment

  Scenario: Remove Composer
    When I run "make clean-composer"
    Then I should get:
      """
      Removing Composer.
      """

  @slow
  Scenario: Install Composer
    When I run "make composer"
    Then I should get:
      """
      Downloading 
      release of Composer.
      Installing 
      """
    When I run "make composer"
    Then I should get:
      """
      Nothing to be done for 'composer'.
      """
