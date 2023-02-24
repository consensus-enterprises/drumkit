@tools @mustache
Feature: Mustache templating
  In order to use Mustache to template files
  As a Drumkit developer
  I need to be able to download and call Mustache.

  Scenario: Ensure mustache can be used by Drumkit.
    Given I bootstrap a clean drumkit environment
     When I run "make mustache"
     Then I should get:
       """
       Downloading mustache release v1.0.0.
       Installing mustache v1.0.0.
       Mustache 1.0.0
       """
     When I run "ls -la .mk/.local/bin"
     Then I should get:
       """
       mustache ->
       """
