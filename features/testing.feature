@testing @example @wip
Feature: Testing tools
  In order to test 
  As a developer
  I need to ensure the proper tools are installed and working

  Scenario: Check that Behat is installed (via Drumkit)
    Given I bootstrap Drumkit
      And I run "make init-behat"
     When I run "which behat"
     Then I should get:
       """
       .mk/.local/bin/behat
       """

  # NOTE: the @debug tag will show the entire output from tests as they run
  @debug
  Scenario: Check that Behat sees both Drumkit and Mink contexts
     When I run "behat -di"
     Then I should get:
      """
      Drumkit\DrumkitContext
      Drupal\DrupalExtension\Context\MinkContext
      """

  @ansible 
  Scenario: Check that DrumkitContext can bootstrap Ansible role code for testing
  # This might look a bit weird, because it'll bootstrap Drumkit itself as if it were an Ansible role
    Given I bootstrap this Ansible role
     And  I run "ls -la .mk"
     Then I should get:
       """
       GNUmakefile
       d
       """
     And  I run "ls -la roles"
     Then I should get:
       """
       .mk
       """
     And  I run "ls -la roles/.mk"
     Then I should get:
       """
       GNUmakefile
       d
       """
