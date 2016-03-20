Feature: Bootstrap Drupal development
  In order to develop and test Drupal extensions
  As a developer
  I need to be able create basic extensions from templates

  @wip
  Scenario: Bootstrap module development
    Given I bootstrap drumkit
     When I run "make drupal-module NAME=my_module"
     #When I run "make drupal-module NAME=my_module CONFIRM=y"
     #Then I should get:
     # """
     # Enter module name:
     # """
     #When I type "My Module"
     #Then I should get:
     # """
     # This will create a new module ('My Module'/my_module) in the current directory.
     # Proceed? (y/n)
     # """
     #When I type "y"
     Then I should get:
      """
      Bootstrapping Drupal module development.
      Creating skeleton for 'my_module' module.
      """
      And the following files should exist:
      """
      my_module.info.yml
      composer.json
      """
      And the file "my_module.info.yml" should contain:
      """
      name: my_module
      """
      And the file "composer.json" should contain:
      """
      "name": "drupal/my_module",
      """


  @disabled
  Scenario: Bootstrap theme development
    Given I bootstrap drumkit
      And I run "make drupal-theme"
     Then I should get:
      """
      """
      And the following files should exist:
      """
      """

  @disabled
  Scenario: Bootstrap profile development
    Given I bootstrap drumkit
      And I run "make drupal-profile"
     Then I should get:
      """
      """
      And the following files should exist:
      """
      """

  @disabled
  Scenario: Bootstrap site development
    Given I bootstrap drumkit
      And I run "make drupal-site"
     Then I should get:
      """
      """
      And the following files should exist:
      """
      """

