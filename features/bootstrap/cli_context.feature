Feature: CLI Context
  In order to write new CLI commands
  As a developer
  I need to be able to test CLI commands

  Scenario: Create a test file in a temporary directory
    Given I am in a temporary directory
     When I run "touch test.txt"
      And I run "ls"
     Then I should get:
       """
       test.txt
       """ 
      And I should not get:
       """
       Makefile
       """ 
