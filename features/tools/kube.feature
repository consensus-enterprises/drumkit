Feature: Install Kubernetes tools locally
  In order to develop on a local Kubernetes instance
  As a developer
  I need to be able run minikube

  Scenario: Remove minikube
    Given I bootstrap drumkit
    When I run "make clean-minikube"
    Then I should get:
      """
      Removing minikube.
      """

  Scenario: Remove kubectl
    Given I bootstrap drumkit
    When I run "make clean-kubectl"
    Then I should get:
      """
      Removing kubectl.
      """

  @slow
  Scenario: Install minikube
    Given I bootstrap drumkit
    When I run "make clean"
    When I run "make minikube"
    Then I should get:
      """
      Downloading the
      Installing the
      release of minikube.
      minikube version:
      """
    When I run "make minikube"
    Then I should get:
      """
      make: Nothing to be done for `minikube'.
      """

  @slow
  Scenario: Install kubectl
    Given I bootstrap drumkit
    When I run "make clean"
    When I run "make kubectl"
    Then I should get:
      """
      Downloading the
      Installing the
      release of kubectl.
      Client Version:
      Server Version:
      """
    When I run "make kubectl"
    Then I should get:
      """
      make: Nothing to be done for `kubectl'.
      """
