@k8s @clean-k8s-environment
Feature: Clean up Kubernetes environment makefiles, config and scripts.
  In order to update environments on Kubernetes clusters,
  As a developer
  I need to be able to remove Kubernetes environment configuration and Drumkit targets.

  Background:
    Given I bootstrap a clean Drumkit environment

  Scenario: Ensure clean-k8s-environment target is defined.
     When I run "make"
     Then I should get:
      """
      clean-k8s-environment
      """

  Scenario: Remove makefiles for a specific environment without removing the base environment files.
    Given I run the Drumkit command "make init-k8s-environment K8S_ENVIRONMENT_NAME=BANANA"
      And the following files should exist:
      """
      build/environments/base/kustomization.yaml
      build/environments/base/storage_data.yaml
      build/environments/base/storage_files.yaml
      build/environments/BANANA/kustomization.yaml
      build/environments/BANANA/namespace.yaml
      drumkit/mk.d/35_environment_BANANA.mk
      """
     When I run the Drumkit command "make clean-k8s-environment K8S_ENVIRONMENT_NAME=BANANA CONFIRM=y"
     Then I should get:
      """
      Removing file: 'build/environments/BANANA/kustomization.yaml'.
      Removing file: 'build/environments/BANANA/namespace.yaml'.
      Removing file: 'drumkit/mk.d/35_environment_BANANA.mk'.
      """
      And the following files should exist:
      """
      build/environments/base/kustomization.yaml
      build/environments/base/storage_data.yaml
      build/environments/base/storage_files.yaml
      """
      And the following files should not exist:
      """
      build/environments/BANANA/kustomization.yaml
      build/environments/BANANA/namespace.yaml
      drumkit/mk.d/35_environment_BANANA.mk
      """
