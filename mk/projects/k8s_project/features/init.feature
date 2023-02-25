@k8s @init-k8s-project
Feature: Initialize Kubernetes project makefiles.
  In order to efficiently develop a Drupal project on Kubernetes
  As a developer
  I need to be able to initialize project makefiles.

  Background:
    Given I bootstrap a clean Drumkit environment

  Scenario: Ensure project initialization target exists
     When I run "make"
     Then I should get:
      """
      init-k8s-project
      """

  Scenario: Initialize project makefiles.
     When I run the Drumkit command "make init-k8s-project"
     Then I should get:
      """
      Creating project makefiles.
      Creating file: 'drumkit/mk.d/20_project.mk'.
      Creating file: 'drumkit/mk.d/20_project_drupal.mk'.
      """
      And the following files should exist:
      """
      drumkit/mk.d/20_project.mk
      drumkit/mk.d/20_project_drupal.mk
      """
