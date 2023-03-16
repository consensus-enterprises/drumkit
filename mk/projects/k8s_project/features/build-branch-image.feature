@k8s @build-branch-image
Feature: Build a Docker image with the latest code from a branch.
  In order to deploy code from a branch to a test environment
  As a developer
  I need to be able to build a Docker image from a branch.

  Background:
    Given I bootstrap a clean Drumkit environment
      And a git repo on branch "test-branch"
     # TODO: add call to .prompt for PROJECT_NAME to makefile;
	 # Also: ensure PROJECT_NAME is persisted in a variables file.
      And I run "echo PROJECT_NAME=test-project >> Makefile"
      And I run "echo CLIENT_NAME=test-client >> Makefile"
      And I run the Drumkit command "make init-k8s-project"
      And I run the Drumkit command "make init-k8s-images"

  Scenario: Ensure build-branch-image target does not exist by default.
    Given I bootstrap a clean Drumkit environment
     When I run "make"
     Then I should not get:
      """
      build-branch-image
      """

  Scenario: Ensure build-branch-image target exists
     When I run "make"
     Then I should get:
      """
      build-branch-image
      """

  Scenario: Run the proper command to build a Docker image from the current branch.
     When I run "make -n build-branch-image"
     Then I should get:
      """
      make -s .build-branch-image
      """
     When I run "make -n .build-branch-image"
     Then I should get:
      """
      You are about to update the Docker image for the 'test-branch' branch.
      Proceed? [y/N]
      DOCKER_IMAGE_TAG=test-branch make -s docker-image-drupal
      """
     When I run "DOCKER_IMAGE_TAG=test-branch make -n docker-image-drupal"
     Then I should get:
      """
      make -s .docker-image DOCKER_IMAGE_NAME=drupal DOCKER_IMAGE_TAG=test-branch
      """

  # @TODO: Move to docker-in-docker (dind) in CI, so that we can actually test this
  # N.B. We will likely need Dockerfile fixtures and such to make this work.
  @wip @minikube @dind
  Scenario: Build a Docker image from the current branch.
   Then I should get:
	"""
    You are about to update the Docker image for the 'test-branch' branch.
    Authenticating with existing credentials...
    Login Succeeded
    Building
    FINISHED                                                                                              
    [internal] load build definition from Dockerfile.drupal
    exporting to image
    exporting layers
    writing image
    naming to
    The push refers to repository
    Preparing 
    test-branch: digest:
	"""
