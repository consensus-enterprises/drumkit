@prompt
Feature: Drumkit prompt function.
  In order to gather user input for use in Drumkit targets
  As a Drumkit developer
  I need to be able to easily prompt users for input.

  Background:
    Given I bootstrap a clean Drumkit environment
      And I run "cp .mk/mk/tasks/features/fixtures/00_prompt_test.mk drumkit/mk.d/"


  Scenario: Only prompt when using the relevant variable.
     When I run the Drumkit command "make target_without_var"
     Then I should get:
      """
      I'm not using MY_VARIABLE.
      """
      And I should not get:
      """
      MY_VARIABLE is: Some default value
      """
     When I run the Drumkit command "make target_with_var"
     Then I should get:
      """
      MY_VARIABLE is: Some default value
      """

  @wip
  Scenario: Prompt with a defined message.
  # @TODO: Figure out how to check the prompt's message itself, since we don't see it in our output.

  Scenario: Set a variable via a prompt.
     When I run the Drumkit command "echo Not the default value | make target_with_var"
     Then I should get:
      """
      MY_VARIABLE is: Not the default value
      """
      And I should not get:
      """
      MY_VARIABLE is: Some default value
      """

  Scenario: Use a variable from a default.
     When I run the Drumkit command "make target_with_var"
     Then I should get:
      """
      MY_VARIABLE is: Some default value
      """

  Scenario: Bypass a prompt by setting the variable explicitly.
     When I run the Drumkit command "MY_VARIABLE='Explicitly set variable' make target_with_var"
     Then I should get:
      """
      MY_VARIABLE is: Explicitly set variable
      """
      And I should not get:
      """
      MY_VARIABLE is: Some default value
      """
