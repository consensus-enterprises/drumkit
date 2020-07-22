@init @drupal8 @project
Feature: Initialize Drupal 8 projects with Lando.
  In order to start a new Drupal 8 project in a Lando environment
  As a Drupal Developer
  I need to be able to initialize Drupal 8 projects

  Background:
    Given I bootstrap Drumkit
      And I run "cp .mk/files/drupal8/drumkit-drupal8.conf.test drumkit-drupal8.conf"

  Scenario: Initialize a Drupal 8 project.
     When I run "make -n init-project-drupal8-deps"
     Then I should get:
     """
     Ensuring PHP dependencies are installed.
     Installing Behat.
     Ensuring Docker is installed.
     in docker group.
     Ensuring Lando is installed.
     """
     When I run "make -n init-project-drupal8"
     Then I should get:
     """
     Initializing Drupal 8 Composer project.
     You can spin up your project using the following commands
     """

  @slow
  Scenario: Sanity check the Composer Drupal 8 project template.
     When I run "make drupal8-composer-codebase"
     Then I should get:
     """
     Initializing Drupal 8 Composer project.
     """
      And the following files should exist:
     """
     composer.json
     composer.lock
     """
      And the following files should not exist:
     """
     tmpdir
     """

  Scenario: Test Drumkit setup of .env and drumkit/ directory contents
     When I run "make drupal8-drumkit-dir"
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

