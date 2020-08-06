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

  Scenario: Install Mustache, but only if it isn't already installed.
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
      exists; do 'make clean-mustache mustache' to delete it and force re-download
      """
     And I run "make clean-mustache mustache"
    Then I should not get:
      """
      exists; do 'make clean-mustache mustache' to delete it and force re-download
      """
     And I should get:
      """
      Cleaning Mustache
      Downloading Mustache
      """
