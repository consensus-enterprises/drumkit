Feature: Bootstrap Drupal development
  In order to develop and test Drupal extensions
  As a developer
  I need to be able create basic extensions from templates

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

  Scenario: Bootstrap theme development
    Given I bootstrap drumkit
      And I run "make drupal-theme NAME=my_theme"
     #When I run "make drupal-theme NAME=my_theme CONFIRM=y"
     #Then I should get:
     # """
     # Enter theme name:
     # """
     #When I type "My Theme"
     #Then I should get:
     # """
     # This will create a new module ('My Theme'/my_theme) in the current directory.
     # Proceed? (y/n)
     # """
     #When I type "y"
     Then I should get:
      """
      Bootstrapping Drupal theme development.
      Creating skeleton for 'my_theme' theme.
      """
      And the following files should exist:
      """
      my_theme.info.yml
      composer.json
      """
      And the file "my_theme.info.yml" should contain:
      """
      name: my_theme
      """
      And the file "composer.json" should contain:
      """
      "name": "drupal/my_theme",
      """

  @wip
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

