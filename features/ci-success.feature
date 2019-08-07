@testing @ci @success 
Feature: CI success
  In order to test 
  As a developer
  I need to ensure that when CI succeeds I get notified.

  Scenario: CI succeeds, notification should be sent.
      Given I run "/bin/true"
