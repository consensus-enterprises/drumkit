Feature: Dynamically include git submodules in projects
  In order to include the right git submodules in my projects
  As a developer
  I need Drumkit to include submodules from a list I pass to it

  @project @submodule @todo
  Scenario: Include submodules from config file
    Given I run "echo 'TODO'"
     Then I should get:
      """
      TODO
      """
