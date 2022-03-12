@tools @go
Feature: Install Go apps locally
  In order to use Go apps
  As a developer
  I need to be able to install Go apps

  Background:
    Given I bootstrap a clean drumkit environment

  Scenario: Remove Hugo
    When I run "make clean-hugo"
    Then I should get:
      """
      Removing Hugo.
      """

  @slow @debug
  Scenario: Install Hugo
    When I run "make hugo"
    Then I should get:
      """
      Downloading the
      Installing the
      release of Hugo.
      hugo v
      extended
      """
    When I run "make hugo"
    Then I should get:
      """
      """

