@init @project @self-bootstrap
Feature: Self-bootstrap Drumkit
  In order to test Drumkit features
  As a DevOps engineer
  I need Drumkit to bootstrap itself cleanly

Scenario:
  Given I bootstrap a clean Drumkit environment
   Then the command "make test-self-bootstrap" should succeed
