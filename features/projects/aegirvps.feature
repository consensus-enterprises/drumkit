@init @aegirvps @project
Feature: Initialize AegirVPS projects.
  In order to use deploy and configure AegirVPS systems
  As a DevOps engineer
  I need to be able to initialize AegirVPS projects

   Scenario: Initialize an AegirVPS project
     Given I bootstrap Drumkit
      When I run "make init-project-aegirvps"
      Then I should get:
       """
       Initializing Drumkit AegirVPS project
       Finished initializing Drumkit AegirVPS project
       """
