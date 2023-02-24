@k8s @init-k8s-cluster
Feature: Kubernetes Cluster
  In order to initialize a Kubernetes cluster
  As a devops engineer
  I need to be able to initialize Kubernetes cluster configuration

  Background:
    Given I bootstrap a clean Drumkit environment

  Scenario: Ensure Kubernetes cluster configuration initialization target exists
     When I run "make"
     Then I should get:
      """
      init-k8s-cluster
      """

  Scenario: Initialize Kubernetes cluster configuration
     When I run the Drumkit command "make init-k8s-cluster"
     Then I should get:
      """
      Creating 'UNSTABLE' cluster
      Creating file:
      Creating symlink:
      To build a cluster
      You should update the documentation
      Created a 'kubectl' alias that uses the correct kubeconfig.
      Remember to re-bootstrap Drumkit.
      """
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
