Feature: Kubernetes Cluster
  In order to initialize a Kubernetes cluster
  As a devops engineer
  I need to be able to initialize Kubernetes cluster configuration

  Scenario: Ensure Kubernetes cluster configuration initialization target exists
    Given I bootstrap Drumkit
     When I run "make"
     Then I should get:
       """
       init-k8s-cluster
       """

  Scenario: Initialize Kubernetes cluster configuration
    Given I bootstrap Drumkit
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
       build/clusters/UNSTABLE/cluster.tf
       build/clusters/UNSTABLE/keypair.tf
       build/clusters/UNSTABLE/terraform.tfvars
       """
