@k8s @init-k8s-drupal-app
Feature: Image config initialization
  In order to build and manage Drupal apps on Kubernetes clusters,
  As a devops engineer,
  I need to be able to initialize configuration and Drumkit targets that create and manage Drupal apps on Kubernetes clusters.

  Background:
    Given I bootstrap a clean Drumkit environment

  Scenario: Ensure docker Drupal app config initialization target exists
     When I run "make"
     Then I should get:
      """
      init-k8s-drupal-app
      """

  Scenario: Initialize Drupal app configuration.
     When I run the Drumkit command "make init-k8s-drupal-app"
     Then I should get:
      """
      Creating Drupal app.
      
      Creating file: 'build/app/base/app-variables.yaml'.
      Creating file: 'build/app/base/cert-manager.yaml'.
      Creating file: 'build/app/base/component-drupal.yaml'.
      Creating file: 'build/app/base/component-mariadb.yaml'.
      Creating file: 'build/app/base/ingress-service.yaml'.
      Creating file: 'build/app/base/job-install-drupal.yaml'.
      Creating file: 'build/app/base/kustomization.yaml'.
      Creating file: 'build/app/base/registry-credentials.yaml'.
      Creating file: 'build/app/DEV/app-secrets.yaml'.
      Creating file: 'build/app/DEV/app-variables.patch.yaml'.
      Creating file: 'build/app/DEV/ingress-service.patch.yaml'.
      Creating file: 'build/app/DEV/kustomization.yaml'.
      Creating file: 'drumkit/mk.d/45_drupal_app_DEV.mk'.
      You must update database and admin passwords in
      'build/app/DEV/app-secrets.yaml'
      
      You must also generate a token to allow Kubernetes to pull images.
      by running 'make gitlab-pull-secret'. This token must be entered in
      build/app/base/registry-credentials.yaml
      
      You should customize the site name and install profile in
      'build/app/base/app-variables.yaml'
      
      Automatic HTTPS certificate generation is now enabled using
      the Let's Encrypt Staging server. You can switch this to production in
      'build/app/base/ingress-service.yaml'
      
      You should update the documentation in the following files to reflect
      the intended use of this app:
      drumkit/mk.d/45_drupal_app_DEV.mk
      
      Additional app variables can be provided in
      'build/app/DEV/app-variables.patch.yaml'
      
      If you want to customise the database image, you can update it in
      'build/app/base/component-mariadb.yaml'
      
      Any special routing that the app requires can be done in
      'build/app/base/ingress-service.yaml'
      """
      And the following files should exist:
      """
      build/app/base/app-variables.yaml
      build/app/base/cert-manager.yaml
      build/app/base/component-drupal.yaml
      build/app/base/component-mariadb.yaml
      build/app/base/ingress-service.yaml
      build/app/base/job-install-drupal.yaml
      build/app/base/kustomization.yaml
      build/app/base/registry-credentials.yaml
      build/app/DEV/app-secrets.yaml
      build/app/DEV/app-variables.patch.yaml
      build/app/DEV/ingress-service.patch.yaml
      build/app/DEV/kustomization.yaml
      drumkit/mk.d/45_drupal_app_DEV.mk
      """

