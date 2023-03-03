@k8s @new-branch-environment
Feature: New environment to test a branch.
  In order to efficiently develop a Drupal project on Kubernetes
  As a developer
  I need to be able to initialize project makefiles.

  Background:
    Given I bootstrap a clean Drumkit environment

  Scenario: Ensure new-branch-environment target does not exist by default.
     When I run "make"
     Then I should not get:
      """
      new-branch-environment
      """

  Scenario: Ensure new-branch-environment target exists
    Given I run the Drumkit command "make init-k8s-project"
     When I run "make"
     Then I should get:
      """
      new-branch-environment
      """

  Scenario: Create new branch environment makefiles and config.
    Given I run "git checkout -b test-branch"
      And I run "git add ."
      And I run "git commit -m'Initial commit.'"
      And I run "echo PROJECT_NAME=test-project >> Makefile"
      And I run "echo CLIENT_NAME=test-client >> Makefile"
      And I run the Drumkit command "make init-k8s-project"
     When I run the Drumkit command "make new-branch-environment CONFIRM=y"
     Then I should get:
      """
      Setting up an environment for branch test-branch.
      Creating 'test-branch' environment.
      Creating Drupal app.
      Creating file: 'build/app/test-branch/component-drupal.patch.yaml'.

      Next step, run: make test-branch-create-environment
      """
      And the following files should exist:
      """
      build/environments/test-branch/kustomization.yaml
      build/environments/test-branch/namespace.yaml
      drumkit/mk.d/35_environment_test-branch.mk
      build/app/test-branch/app-secrets.yaml
      build/app/test-branch/app-variables.patch.yaml
      build/app/test-branch/component-drupal.patch.yaml
      build/app/test-branch/job-install-drupal.patch.yaml
      build/app/test-branch/ingress-service.patch.yaml
      build/app/test-branch/kustomization.yaml
      drumkit/mk.d/45_drupal_app_test-branch.mk
      build/app/test-branch/app-secrets.yaml
      """
      And the file "build/app/test-branch/component-drupal.patch.yaml" should contain:
      """
      image: registry.gitlab.com/consensus.enterprises/clients/test-client/test-project/drupal:test-branch
      """
      And the file "build/app/test-branch/job-install-drupal.patch.yaml" should contain:
      """
      image: registry.gitlab.com/consensus.enterprises/clients/test-client/test-project/drupal:test-branch
      """
