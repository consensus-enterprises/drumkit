@k8s @refresh
Feature: Update test environment to latest code.
  In order to efficiently develop a Drupal project on Kubernetes
  As a developer
  I need to be able to deploy the latest code from a branch to a test environment.

  Background:
    Given I bootstrap a clean Drumkit environment
      And a git repo on branch "test-branch"
      And I run "echo PROJECT_NAME=test-project >> Makefile"
      And I run "echo CLIENT_NAME=test-client >> Makefile"
      And I run the Drumkit command "make init-k8s-project"
#      And I run the Drumkit command "make init-k8s-drupal-app"
#      And I run the Drumkit command "make new-branch-environment CONFIRM=y"
      And I run the Drumkit command "make .k8s-init-branch-environment"

  Scenario: Ensure refresh target does not exist by default.
    Given I bootstrap a clean Drumkit environment
     When I run "make"
     Then I should not get:
      """
      refresh
      """

  Scenario: Ensure refresh target exists
    Given I run the Drumkit command "make init-k8s-project"
     When I run "make"
     Then I should get:
      """
      refresh
      """

  Scenario: Ensure the proper commands are run when refreshing a branch environment.
     When I run "make -n refresh"
     Then I should get:
      """
      make -s .refresh-branch-environment
      """
     When I run "make -n .refresh-branch-environment"
     Then I should get:
      """
      You are about to update the 'test-branch' environment with the latest changes in the branch.
      Proceed? [y/N]
      make -s build-branch-image CONFIRM=y
    """

  # @TODO: Move to docker-in-docker (dind) in CI, so that we can actually test this
  # N.B. We will likely need a basic Drupal project to actually work.
  @wip @minikube @dind
  Scenario: Run the proper command to refresh a branch environment.
     When I run "make refresh"
	#TODO: capture output and complete this test.
