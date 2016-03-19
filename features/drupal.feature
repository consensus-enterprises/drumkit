Feature: Bootstrap Drupal development
  In order to develop and test Drupal extensions
  As a developer
  I need to be able create basic extensions from templates

  @wip
  Scenario: Bootstrap module development
    Given I bootstrap drumkit
      And I run "make drupal-module"
     Then I should get:
      """
      """
      And the following files should exist
      """
      """

  @disabled
  Scenario: Bootstrap theme development
    Given I bootstrap drumkit
      And I run "make drupal-theme"
     Then I should get:
      """
      """
      And the following files should exist
      """
      """

  @disabled
  Scenario: Bootstrap profile development
    Given I bootstrap drumkit
      And I run "make drupal-profile"
     Then I should get:
      """
      """
      And the following files should exist
      """
      """

  @disabled
  Scenario: Bootstrap site development
    Given I bootstrap drumkit
      And I run "make drupal-site"
     Then I should get:
      """
      """
      And the following files should exist
      """
      """

