@k8s @k8s-init-images
Feature: Image config initialization
  In order to build Docker images for Drupal apps on Kubernetes
  As a devops engineer
  I need to be able to initialize Docker image config 

  @wip
  Scenario: Create a test file in a temporary directory
    Given I am in a temporary directory
     When I run "touch test.txt"
      And I run "ls"
     Then I should get:
       """
       test.txt
       """ 
      And I should not get:
       """
       Makefile
       """ 
