@init @aegir @project
Feature: Initialize Aegir projects
  In order to deploy, configure and manage Aegir
  As a DevOps engineer
  I need to be able to initialize Aegir projects

  Scenario: Initialize an Aegir project.
    Given I bootstrap Drumkit
      And I run "git init"
      And I run "make init-project-aegir"
     Then I should get:
      """
      Initializing Drumkit Aegir project
      Finished initializing Drumkit Aegir project
      """
     # TODO: only test for `roles/consensus.aegir-policy`, and move checks for
     # others into a test in that role.
     Then the following files should exist:
      """
      roles/consensus.aegir-policy
      roles/consensus.aegir
      roles/consensus.aegir-skynet
      roles/consensus.utils
      roles/geerlingguy.composer
      roles/geerlingguy.drush
      roles/geerlingguy.git
      roles/geerlingguy.mysql
      roles/geerlingguy.php
      playbooks/groups/aegir.yml
      """
