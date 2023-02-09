Feature: Mustache templating
  In order to deploy context-specific files in Drumkit projects
  As a devops engineer
  I need to be able to interpolate data into template files generically.

  Scenario: Ensure mustache can be used by Drumkit
    Given I bootstrap Drumkit
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
     When I run the Drumkit command "make .template TEMPLATE_VARS='REPLACEME=FOO' TEMPLATE_SOURCE=.mk/mk/tasks/features/fixtures/example.txt TEMPLATE_TARGETDIR=. TEMPLATE_TARGET=example.txt"
     Then the file "example.txt" should contain:
       """
       FOO
       """
