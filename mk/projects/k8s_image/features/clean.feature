@k8s @clean-k8s-images
Feature: Clean up Docker image makefiles, config and scripts.
  In order to update Docker image makefiles, config and scripts,
  As a developer
  I need to be able to remove Docker image makefiles, config and scripts.

  Background:
    Given I bootstrap a clean Drumkit environment
      And I run the Drumkit command "make init-k8s-images"
      And the following files should exist:
      """ 
      build/images/docker/Dockerfile.base
      build/images/scripts/apt.sh
      build/images/scripts/cleanup.sh
      build/images/scripts/utils.sh
      build/images/scripts/app.sh
      build/images/files/install-drupal.sh
      build/images/files/nginx.conf
      build/images/files/start-drupal.sh
      web/sites/default/settings.php
      build/images/docker/Dockerfile.drupal
      drumkit/mk.d/15_images.mk
      """

  Scenario: Remove project makefiles.
     When I run the Drumkit command "make clean-k8s-images"
     Then I should get:
      """ 
      Removing file: 'build/images/docker/Dockerfile.base'.
      Removing file: 'build/images/scripts/apt.sh'.
      Removing file: 'build/images/scripts/cleanup.sh'.
      Removing file: 'build/images/scripts/utils.sh'.
      Removing file: 'build/images/scripts/app.sh'.
      Removing file: 'build/images/files/install-drupal.sh'.
      Removing file: 'build/images/files/nginx.conf'.
      Removing file: 'build/images/files/start-drupal.sh'.
      Removing file: 'web/sites/default/settings.php'.
      Removing file: 'build/images/docker/Dockerfile.drupal'.
      """
      And the following files should not exist:
      """ 
      build/images/docker/Dockerfile.base
      build/images/scripts/apt.sh
      build/images/scripts/cleanup.sh
      build/images/scripts/utils.sh
      build/images/scripts/app.sh
      build/images/files/install-drupal.sh
      build/images/files/nginx.conf
      build/images/files/start-drupal.sh
      web/sites/default/settings.php
      build/images/docker/Dockerfile.drupal
      drumkit/mk.d/15_images.mk
      """
