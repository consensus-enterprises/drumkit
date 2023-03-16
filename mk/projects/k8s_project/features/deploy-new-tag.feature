@wip @k8s @deploy-new-tag
Feature: Deploying new tag to a stable environment.
  In order to efficiently develop a Drupal project on Kubernetes
  As a devops engineer,
  I need to be able to deploy a new tag to a stable environment.

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
     Then file "build/app/test-branch/component-drupal.patch.yaml" has changed
     Then file "build/app/test-branch/job-install-drupal.patch.yaml" has changed
     And the file "build/app/test-branch/component-drupal.patch.yaml" should contain:
      """
      image: registry.gitlab.com/consensus.enterprises/clients/test-client/test-project/drupal:mytag
      """
     And the file "build/app/test-branch/job-install-drupal.patch.yaml" should contain:
      """
      image: registry.gitlab.com/consensus.enterprises/clients/test-client/test-project/drupal:mytag
      """
