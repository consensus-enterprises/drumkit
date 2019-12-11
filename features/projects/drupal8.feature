@init @drupal8 @project
Feature: Initialize Drupal 8 projects with Lando.
  In order to start a new Drupal 8 project in a Lando environment
  As a Drupal Developer
  I need to be able to initialize Drupal 8 projects

  Background:
    Given I bootstrap Drumkit
      And I run "cp .mk/files/drupal8/drumkit-drupal8.conf.test drumkit-drupal8.conf"

  Scenario: Initialize a Drupal 8 project.
     When I run "make -n init-project-drupal8"
     Then I should get:
     """
     Initializing Drumkit Drupal 8 project
     Installing python dependencies so that Drumkit can use ansible and jinja2.
     Installing PHP dependencies.
     Installing Behat.
     Installing Docker.
     to docker group.
     Installing Lando.
     Creating Composer project from drupal-project template.
     """

  @slow
  Scenario: Sanity check the Composer Drupal 8 project template.
     When I run "make init-composer-drupal8-project"
     Then I should get:
     """
     Creating Composer project from drupal-project template
     """
      And the following files should exist:
     """
     vendor
     web
     web/core
     web/index.php
     """
      And the following files should not exist:
     """
     tmpdir
     """

  Scenario: Test Drumkit setup of .env and drumkit/ directory contents
     When I run "make init-drupal8-drumkit"
     Then I should get:
     """
	   Setting up drumkit directory.
     """
     And the following files should exist:
     """
     .env
     drumkit/bootstrap.d/40_lando.sh
     """
     And the file ".env" should contain:
     """
	   COMPOSER_CACHE_DIR=tmp/composer-cache/
     """
     And the file "drumkit/bootstrap.d/40_lando.sh" should contain:
     """
	   export $(cat .env | xargs)
     """
     And the following files should exist:
     """
     .lando.yml
     drumkit/mk.d/10_variables.mk
     drumkit/mk.d/20_lando.mk
     drumkit/mk.d/30_build.mk
     drumkit/mk.d/40_install.mk
     """
     And the following files should not exist:
     """
     .drumkit-drupal8-init-variables.cmd
     .drumkit-drupal8-init-lando.cmd
     """
     And the file "drumkit/mk.d/10_variables.mk" should contain:
     """
     mydrupalsite
     My Drupal Site
     drupal8
     dev
     pwd
     """
     And the file ".lando.yml" should contain:
     """
     mydrupalsite
     user: drupal8
     password: drupal8
     database: drupal8
     """

