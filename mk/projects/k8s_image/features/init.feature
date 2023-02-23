@k8s @k8s-init-images
Feature: Image config initialization
  In order to build Docker images for Drupal apps on Kubernetes
  As a devops engineer
  I need to be able to initialize Docker image config.

  Scenario: Initialize Docker image configuration.
    Given I bootstrap Drumkit
     When I run the Drumkit command "make init-k8s-images"
     Then I should get:
      """
      Creating file: 'build/images/docker/Dockerfile.base'.
      Creating file: 'build/images/scripts/apt.sh'.
      Creating file: 'build/images/scripts/cleanup.sh'.
      Creating file: 'build/images/scripts/utils.sh'.
      To alter the 'base' image, you will need to update
      'build/images/docker/Dockerfile.base', then run:
      'make docker-image-base'

      To install additional utilities, you can update
      'build/images/scripts/utils.sh'

      Creating file: 'build/images/scripts/app.sh'.
      Creating file: 'build/images/files/install-drupal.sh'.
      Creating file: 'build/images/files/nginx.conf'.
      Creating file: 'build/images/files/start-drupal.sh'.
      Creating file: 'web/sites/default/settings.php'.
      Creating file: 'build/images/docker/Dockerfile.drupal'.

      To alter the 'drupal' image, you will need to update
      'build/images/docker/Dockerfile.drupal', then run:
      'make docker-image-drupal'

      To install additional system-level dependencies, you can update
      'build/images/docker/scripts/app.sh'

      To change Nginx configuration, you can update:
      'build/images/files/nginx.conf'

      To change how Drupal is installed, you can update:
      'build/images/files/install-drupal.sh'

      Creating file: 'drumkit/mk.d/15_images.mk'.
      """
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

