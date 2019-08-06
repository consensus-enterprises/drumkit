@init @aegir @project
Feature: Initialize Aegir projects
  In order to deploy, configure and manage Aegir
  As a DevOps engineer
  I need to be able to initialize Aegir projects

  Scenario: Initialize an Aegir project.
    Given I bootstrap Drumkit
     When I run "make init-project-aegir"
     Then I should get:
      """
      Initializing Drumkit Aegir project
      Finished initializing Drumkit Aegir project
      """
      And the following files should exist:
      """
      roles/consensus.aegir-policy
      """
