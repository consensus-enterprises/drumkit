@k8s @clean-k8s-drupal-app
Feature: Clean up Docker image makefiles, config and scripts.
  In order to update Drupal apps on Kubernetes clusters,
  As a developer
  I need to be able to remove configuration and Drumkit targets that create and manage Drupal apps on Kubernetes clusters.

  Background:
    Given I bootstrap a clean Drumkit environment

  Scenario: Ensure clean-k8s-drupal-app target is defined.
     When I run "make"
     Then I should get:
      """
      clean-k8s-drupal-app
      """

  Scenario: Remove project makefiles.
    Given I run the Drumkit command "make init-k8s-drupal-app"
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
     When I run the Drumkit command "make clean-k8s-drupal-app"
     Then I should get:
      """
      Removing file: 'build/app/base/app-variables.yaml'.
      Removing file: 'build/app/base/cert-manager.yaml'.
      Removing file: 'build/app/base/component-drupal.yaml'.
      Removing file: 'build/app/base/component-mariadb.yaml'.
      Removing file: 'build/app/base/ingress-service.yaml'.
      Removing file: 'build/app/base/job-install-drupal.yaml'.
      Removing file: 'build/app/base/kustomization.yaml'.
      Removing file: 'build/app/base/registry-credentials.yaml'.
      Removing file: 'build/app/DEV/app-secrets.yaml'.
      Removing file: 'build/app/DEV/app-variables.patch.yaml'.
      Removing file: 'build/app/DEV/ingress-service.patch.yaml'.
      Removing file: 'build/app/DEV/kustomization.yaml'.
      Removing file: 'drumkit/mk.d/45_drupal_app_DEV.mk'.
      """
      And the following files should not exist:
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
