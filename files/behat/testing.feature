@testing @example
Feature: Testing tools
  In order to test 
  As a developer
  I need to be able to ensure the proper tools are installed

  Scenario: Check that Behat is installed (via Drumkit)
     When I run "make behat"
      And I run "which behat"
     Then I should get:
       """
       .mk/.local/bin/behat
       """

  Scenario: Check that Behat sees both Drumkit and Mink contexts
     When I run "behat -di"
     Then I should get:
      """
      Drumkit\DrumkitContext
      Drupal\DrupalExtension\Context\MinkContext
      """
