@k8s @new-branch-environment
Feature: New environment to test a branch.
  In order to efficiently develop a Drupal project on Kubernetes
  As a developer
  I need to be able to initialize project makefiles.

  Background:
    Given I bootstrap a clean Drumkit environment
     # TODO: add call to .prompt for PROJECT_NAME to makefile;
	 # Also: ensure PROJECT_NAME is persisted in a variables file.
      And I run "echo PROJECT_NAME=test-project >> Makefile"
      And I run "echo CLIENT_NAME=test-client >> Makefile"

  Scenario: Ensure new-branch-environment target does not exist by default.
     When I run "make"
     Then I should not get:
      """
      new-branch-environment
      """

  Scenario: Ensure new-branch-environment target exists
    Given I run the Drumkit command "make init-k8s-project"
     When I run "make"
     Then I should get:
      """
      new-branch-environment
      """

  Scenario: Create new branch environment makefiles and config.
    Given a git repo on branch "test-branch"
      And I run the Drumkit command "make init-k8s-project"
     When I run the Drumkit command "make -n new-branch-environment CONFIRM=y"
     Then I should get:
      """
      make -s .new-branch-environment
      """
     When I run the Drumkit command "make -n .new-branch-environment CONFIRM=y"
     Then I should get:
      """
      echo -e "You are about to create a new branch environment for: 'test-branch'."
      echo -e "Setting up an environment for branch test-branch."
      make -s init-k8s-environment \
                  K8S_ENVIRONMENT_NAME=test-branch
      make -s init-k8s-drupal-app \
                  K8S_DRUPAL_APP_IMAGE_TAG=test-branch \
                  K8S_ENVIRONMENT_NAME=test-branch
      make -s test-branch-create-environment
      make -s build-branch-image CONFIRM=y
      make -s test-branch-deploy-app
      """
     When I run the Drumkit command "make .k8s-init-branch-environment"
     Then I should get:
      """
      Setting up an environment for branch test-branch.
      Creating 'test-branch' environment.
      Creating Drupal app.
      Creating file: 'build/app/test-branch/component-drupal.patch.yaml'.
      """
      And the following files should exist:
      """
      build/environments/test-branch/kustomization.yaml
      build/environments/test-branch/namespace.yaml
      drumkit/mk.d/35_environment_test-branch.mk
      build/app/test-branch/app-secrets.yaml
      build/app/test-branch/app-variables.patch.yaml
      build/app/test-branch/component-drupal.patch.yaml
      build/app/test-branch/job-install-drupal.patch.yaml
      build/app/test-branch/ingress-service.patch.yaml
      build/app/test-branch/kustomization.yaml
      drumkit/mk.d/45_drupal_app_test-branch.mk
      build/app/test-branch/app-secrets.yaml
      """
      And the file "build/app/test-branch/component-drupal.patch.yaml" should contain:
      """
      image: registry.gitlab.com/consensus.enterprises/clients/test-client/test-project/drupal:test-branch
      """
      And the file "build/app/test-branch/job-install-drupal.patch.yaml" should contain:
      """
      image: registry.gitlab.com/consensus.enterprises/clients/test-client/test-project/drupal:test-branch
      """

  @wip @minikube @dind
  Scenario: Create new branch environment makefiles and config.
    Given a git repo on branch "test-branch"
      And I run the Drumkit command "make init-k8s-project"
     When I run the Drumkit command "make new-branch-environment CONFIRM=y"
     Then I should get:
	"""
    You are about to create a new branch environment for: 'test-branch'.
    Setting up an environment for branch test-branch.
    >>> Creating 'test-branch' environment. <<<
    Switching to 'UNSTABLE' cluster.
    Context "test-branch" modified.
    Creating 'test-branch' environment on 'UNSTABLE' cluster.
    namespace/test-branch created
    persistentvolumeclaim/data-persistent-volume-claim created
    persistentvolumeclaim/files-persistent-volume-claim created
    Waiting for storage to be fully provisioned in 'test-branch' environment.
    Storage provisioning took
    You are about to update the Docker image for the 'test-branch' branch.
    FINISHED                                                                                              
    [internal] load build definition from Dockerfile.drupal
    Deploying app to 'test-branch'.
    Switching to 'UNSTABLE' cluster.
    Setting environment to test-branch on the UNSTABLE cluster.
    Switched to context "test-branch".
    configmap/app-variables created
    secret/app-secrets created
    secret/registry-credentials created
    service/drupal-cluster-ip-service created
    service/mariadb-cluster-ip-service created
    deployment.apps/drupal-deployment created
    deployment.apps/mariadb-deployment created
    job.batch/job-install-drupal created
    clusterissuer.cert-manager.io/letsencrypt-prod unchanged
    clusterissuer.cert-manager.io/letsencrypt-staging unchanged
    ingress.networking.k8s.io/ingress-service created
	"""
	When I run "kubectl get all"
	Then I should get:
    """
    pod/drupal-deployment-
    pod/job-install-drupal-
    pod/mariadb-deployment-
    service/drupal-cluster-ip-service    ClusterIP
    service/mariadb-cluster-ip-service   ClusterIP
    deployment.apps/drupal-deployment
    deployment.apps/mariadb-deployment
    replicaset.apps/drupal-deployment-
    replicaset.apps/mariadb-deployment-
    job.batch/job-install-drupal

    """
