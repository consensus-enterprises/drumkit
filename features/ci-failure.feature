@testing @ci @failure @noisy
Feature: CI failure
  In order to test 
  As a developer
  I need to ensure that when CI fails I get notified.

  Scenario: CI fails, notification should be sent.
      Given I run "/bin/false"
