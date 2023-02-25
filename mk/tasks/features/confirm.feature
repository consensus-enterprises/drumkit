@confirm-proceed
Feature: Confirmation prompt.
  In order to avoid unintended actions
  As a Drumkit developer
  I need to be able to prompt users for confirmation.

  Background:
    Given I bootstrap a clean Drumkit environment

  Scenario: Prompt for confirmation.
     When I run "echo y | make .confirm-proceed"
     Then I should get:
       """
       Proceed? [y/N]
       """
      And I should not get:
       """
       if
       then
       else
       read
       """

  Scenario: Proceed without error when confirmation is approved.
     When I run "echo y | make .confirm-proceed"
     Then I should get:
       """
       Proceed? [y/N]
       """
      And I should not get:
       """
       .confirm-proceed] Error 1
       """

  Scenario: Throw error when confirmation denied.
     When I try to run "echo N | make .confirm-proceed"
     Then I should get:
       """
       .confirm-proceed] Error 1
       """

  Scenario: Skip prompt via environment variable.
     When I run "make .confirm-proceed CONFIRM=y"
     Then I should get:
       """
       CONFIRM variable set. Proceeding without confirmation prompt.
       """
