@tools @mustache
Feature: Install Mustache locally
  In order to interpolate template variables
  As a developer
  I need to be able run Mustache

  Background:
    Given I bootstrap a clean drumkit environment

  Scenario: Remove Mustache
    When I run "make clean-mustache"
    Then I should get:
      """
      Cleaning Mustache
      """
    And executing "which mustache" should fail

  Scenario: Install Mustache
    When I run "unset DRUMKIT && source d && make clean-mustache mustache"
    Then I should get:
      """
      Cleaning Mustache
      Downloading Mustache
      """
     And the following files should exist:
      """
      .mk/.local/bin/mustache
      """
     And I run "make mustache"
    Then I should get:
      """
      Nothing to be done for 'mustache'.
      """
