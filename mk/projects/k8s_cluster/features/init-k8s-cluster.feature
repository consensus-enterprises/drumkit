Feature: Kubernetes Cluster
  In order to initialize a Kubernetes cluster
  As a devops engineer
  I need to be able to initialize Kubernetes cluster configuration

  Scenario: Initialize Kubernetes cluster configuration
    Given I bootstrap Drumkit
     When I run "make"
     Then I should get:
       """
       init-k8s-cluster
       """ 
