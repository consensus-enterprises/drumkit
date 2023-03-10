@k8s @clean-k8s-project
Feature: Clean up project makefiles.
  In order to update project makefiles
  As a developer
  I need to be able to remove project makefiles.

  Background:
    Given I bootstrap a clean Drumkit environment

  Scenario: Ensure clean-k8s-project target is defined.
     When I run "make"
     Then I should get:
      """
      clean-k8s-project
      """

  Scenario: Remove project makefiles.
    Given I run the Drumkit command "make init-k8s-project PROJECT_NAME=foo"
      And the following files should exist:
      """
      drumkit/mk.d/20_project.mk
      drumkit/mk.d/20_project_drupal.mk
      """
     When I run the Drumkit command "make clean-k8s-project"
     Then I should get:
      """
      Cleaning up project makefiles.
      Removing file: 'drumkit/mk.d/20_project.mk'.
      Removing file: 'drumkit/mk.d/20_project_drupal.mk'.
      """
      And the following files should not exist:
      """
      drumkit/mk.d/20_project.mk
      drumkit/mk.d/20_project_drupal.mk
      """
