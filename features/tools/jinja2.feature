@tools @jinja2
Feature: Install jinja2 locally
  In order to use jinja2
  As a developer
  I need to be able to install jinja2

  Background:
    Given I bootstrap a clean drumkit environment
    And I run "deactivate"

  Scenario: Remove jinja2 
    When I run "make clean-jinja2"
    Then I should get:
      """
      Cleaning jinja2.
      """

  Scenario: Install jinja2, but not if it's already installed.
    When I run "make jinja2"
    Then I should get:
      """
      Installing jinja2
      Collecting jinja2-cli
      Successfully installed
      """
    When I run "make jinja2"
    Then I should get:
      """
      Found jinja2-cli already in your kit
      """

