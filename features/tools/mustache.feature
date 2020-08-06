@tools @mustache
Feature: Install mustache locally
  In order to interpolate template variables
  As a developer
  I need to be able run mustache

  Background:
    Given I bootstrap a clean drumkit environment

  Scenario: Remove mustache
    When I run "make clean-mustache"
    Then I should get:
      """
      Cleaning mustache
      """
    And executing "which mustache" should fail

  @debug
  Scenario: Install mustache, but only if it isn't already installed.
    When I run "unset DRUMKIT && source d && make clean-mustache mustache"
    Then I should get:
      """
      Cleaning mustache
      Downloading mustache
      Installing mustache
      Mustache
      """
     And the following files should exist:
      """
      .mk/.local/bin/mustache
      """
     And I run "make mustache"
    Then I should not get:
      """
      Downloading mustache
      Installing mustache
      """
     And I run "make clean-mustache mustache"
     And I should get:
      """
      Cleaning mustache
      Downloading mustache
      Installing mustache
      """
