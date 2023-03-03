@k8s @refresh
Feature: Update test environment to latest code.
  In order to efficiently develop a Drupal project on Kubernetes
  As a developer
  I need to be able to deploy the latest code from a branch to a test environment.

  Background:
    Given I bootstrap a clean Drumkit environment
      And I run "git checkout -b test-branch"
      And I run "git add ."
      And I run "git commit -m'Initial commit.'"
      And I run "echo PROJECT_NAME=test-project >> Makefile"
      And I run "echo CLIENT_NAME=test-client >> Makefile"
      And I run the Drumkit command "make init-k8s-project"
      And I run the Drumkit command "make init-k8s-drupal-app"
      And I run the Drumkit command "make new-branch-environment CONFIRM=y"

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

  Scenario: Run the proper command to refresh a branch environment.
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
      make -s .re-create \
          FILENAME=build/app/test-branch/component-drupal.patch.yaml \
          K8S_DRUPAL_APP_IMAGE_TAG=test-branch \
          K8S_ENVIRONMENT_NAME=test-branch
    """
     When I run "make -n .re-create FILENAME=build/app/test-branch/component-drupal.patch.yaml DRUPAL_CONTAINER_IMAGE_TAG=test-branch"
     Then I should get:
      """
      rm build/app/test-branch/component-drupal.patch.yaml
      make -s build/app/test-branch/component-drupal.patch.yaml
      """
     When I run "rm build/app/test-branch/component-drupal.patch.yaml"
      And I run the Drumkit command "make build/app/test-branch/component-drupal.patch.yaml FILENAME=build/app/test-branch/component-drupal.patch.yaml DRUPAL_CONTAINER_IMAGE_TAG=test-branch K8S_ENVIRONMENT_NAME=test-branch"
     Then I should get:
      """
      Creating file: 'build/app/test-branch/component-drupal.patch.yaml'.
      """
      And the following files should exist:
      """
      build/app/test-branch/component-drupal.patch.yaml
      """

  Scenario: Generate the proper config to refresh a branch environment.
    Given I record a reference hash of "build/app/test-branch/component-drupal.patch.yaml"
      And I record a reference hash of "build/app/test-branch/job-install-drupal.patch.yaml"
     When I run the Drumkit command "echo y | make refresh"
     Then I should get:
      """
      You are about to update the 'test-branch' environment with the latest changes in the branch.
      Proceed? [y/N]
      """
      # @TODO: We've commented out the part that actually builds the image.
      #You are about to update the Docker image for the 'test-branch' branch.
      #CONFIRM variable set. Proceeding without confirmation prompt.
      And the following files should exist:
      """
      build/app/test-branch/component-drupal.patch.yaml
      build/app/test-branch/job-install-drupal.patch.yaml
      """
     Then file "build/app/test-branch/component-drupal.patch.yaml" has not changed
     Then file "build/app/test-branch/job-install-drupal.patch.yaml" has not changed
     And the file "build/app/test-branch/component-drupal.patch.yaml" should contain:
      """
      image: registry.gitlab.com/consensus.enterprises/clients/test-client/test-project/drupal:test-branch
      """
     And the file "build/app/test-branch/job-install-drupal.patch.yaml" should contain:
      """
      image: registry.gitlab.com/consensus.enterprises/clients/test-client/test-project/drupal:test-branch
      """

  # @TODO: Move to docker-in-docker (dind) in CI, so that we can actually test this
  # N.B. We will likely need a basic Drupal project to actually work.
  @wip
  Scenario: Refresh a branch environment.
