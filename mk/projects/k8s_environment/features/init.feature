@k8s @init-k8s-environment
Feature: Environment config initialization
  In order to build and manage environments on Kubernetes clusters,
  As a devops engineer,
  I need to be able to initialize configuration and Drumkit targets that create and manage environments on Kubernetes clusters.

  Background:
    Given I bootstrap a clean Drumkit environment

  Scenario: Fail without environment name.
	 When I fail to run "make init-k8s-environment"
     Then I should get:
      """
      Variable K8S_ENVIRONMENT_NAME not set
      """

  Scenario: Ensure docker Drupal environment config initialization target exists
     When I run "make"
     Then I should get:
      """
      init-k8s-environment
      """

  Scenario: Initialize environment configuration.
     When I run the Drumkit command "make init-k8s-environment K8S_ENVIRONMENT_NAME=FOO"
     Then I should get:
      """
      Creating 'FOO' environment.
      
      You should update the documentation in the following files to reflect
      the intended use of this environment:
      drumkit/mk.d/35_environment_FOO.mk
      
      If you need to add additional storage or otherwise customize the environment,
      take a look at the files in 'build/environments'.
      
      Creating file: 'build/environments/base/kustomization.yaml'.
      Creating file: 'build/environments/base/storage_data.yaml'.
      Creating file: 'build/environments/base/storage_files.yaml'.
      Creating file: 'build/environments/FOO/kustomization.yaml'.
      Creating file: 'build/environments/FOO/namespace.yaml'.
      Creating file: 'drumkit/mk.d/35_environment_FOO.mk'.
      """
      And the following files should exist:
      """
      build/environments/base/kustomization.yaml
      build/environments/base/storage_data.yaml
      build/environments/base/storage_files.yaml
      build/environments/FOO/kustomization.yaml
      build/environments/FOO/namespace.yaml
      drumkit/mk.d/35_environment_FOO.mk
      """
