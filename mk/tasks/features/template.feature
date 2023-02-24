Feature: Templating
  In order to deploy context-specific files in Drumkit projects
  As a devops engineer
  I need to be able to interpolate data into template files generically.

  Scenario: Generate a file with interpolated variables.
    Given I bootstrap a clean drumkit environment
     When I run the Drumkit command "make .template TEMPLATE_VARS='REPLACEME=FOO' TEMPLATE_SOURCE=.mk/mk/tasks/features/fixtures/example.txt TEMPLATE_TARGETDIR=. TEMPLATE_TARGET=example.txt"
     Then I should get:
       """
       Creating file: 'example.txt'
       """
      And the file "example.txt" should contain:
       """
       FOO
       """
