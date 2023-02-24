@k8s @clean-k8s-cluster
Feature: Clean up Docker image makefiles, config and scripts.
  In order to update Docker image makefiles, config and scripts,
  As a developer
  I need to be able to remove Docker image makefiles, config and scripts.

  Background:
    Given I bootstrap a clean Drumkit environment

  Scenario: Ensure clean-k8s-cluster target is defined.
     When I run "make"
     Then I should get:
      """
      clean-k8s-cluster
      """

  Scenario: Remove project makefiles.
    Given I run the Drumkit command "make init-k8s-cluster"
      And the following files should exist:
      """
      build/clusters/base/providers.tf
      build/clusters/base/variables.tf
      build/clusters/base/versions.tf
      build/clusters/.gitignore
      drumkit/bootstrap.d/40_kubernetes.sh
      build/clusters/UNSTABLE/cluster.tf
      build/clusters/UNSTABLE/keypair.tf
      build/clusters/UNSTABLE/terraform.tfvars
      build/clusters/UNSTABLE/providers.tf
      build/clusters/UNSTABLE/variables.tf
      build/clusters/UNSTABLE/versions.tf
      drumkit/mk.d/25_cluster_UNSTABLE.mk
      """
     When I run the Drumkit command "make clean-k8s-cluster"
     Then I should get:
      """
      Cleaning up configuration and Drumkit targets for managing Kubernetes clusters.
      
      Removing file: 'build/clusters/base/providers.tf'.
      Removing file: 'build/clusters/base/variables.tf'.
      Removing file: 'build/clusters/base/versions.tf'.
      Removing file: 'build/clusters/.gitignore'.
      Removing file: 'drumkit/bootstrap.d/40_kubernetes.sh'.
      Removing file: 'build/clusters/UNSTABLE/cluster.tf'.
      Removing file: 'build/clusters/UNSTABLE/keypair.tf'.
      Removing file: 'build/clusters/UNSTABLE/terraform.tfvars'.
      Removing file: 'build/clusters/UNSTABLE/providers.tf'.
      Removing file: 'build/clusters/UNSTABLE/variables.tf'.
      Removing file: 'build/clusters/UNSTABLE/versions.tf'.
      Removing file: 'drumkit/mk.d/25_cluster_UNSTABLE.mk'.
      """
      And the following files should not exist:
      """
      build/clusters/base/providers.tf
      build/clusters/base/variables.tf
      build/clusters/base/versions.tf
      build/clusters/.gitignore
      drumkit/bootstrap.d/40_kubernetes.sh
      build/clusters/UNSTABLE/cluster.tf
      build/clusters/UNSTABLE/keypair.tf
      build/clusters/UNSTABLE/terraform.tfvars
      build/clusters/UNSTABLE/providers.tf
      build/clusters/UNSTABLE/variables.tf
      build/clusters/UNSTABLE/versions.tf
      drumkit/mk.d/25_cluster_UNSTABLE.mk
      """
