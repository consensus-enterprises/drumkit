Feature: Install drumkit
  In order to use drumkit's features
  As a Drupal developer
  I need to be able to install drumkit easily

  Scenario: Fail if installer is not running in the root of a git repo
    Given I am in a temporary directory
     Then executing "scripts/install.sh" should fail
      And I should get:
       """
       ERROR: This script must be run at the root of a git repository.
       """    

  @debug
  Scenario: Succeed if installer is running in the root of a git repo
    Given I am in a temporary directory
      And I run "git init"
      And I execute "scripts/install.sh"
     Then I should not get:
       """
       ERROR: This script must be run at the root of a git repository.
       """
      And the following files should exist:
       """
       Makefile
       .mk/GNUmakefile
       """
