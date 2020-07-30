@init @drupal8 @project
Feature: Initialize Drupal projects with Lando.
  In order to start a new Drupal project in a Lando environment
  As a Drupal Developer
  I need to be able to initialize Drupal projects

  Background:
    Given I bootstrap Drumkit

  Scenario: Initialize a Drupal project.
     When I run "make -n init-project-drupal-deps"
     Then I should get:
     """
     Ensuring PHP dependencies are installed.
     Installing Behat.
     Ensuring Docker is installed.
     in docker group.
     Ensuring Lando is installed.
     """
     When I run "make -n init-project-drupal"
     Then I should get:
     """
     Initializing Drupal Composer project.
     You can spin up your project using the following commands
     """

  @slow
  Scenario: Sanity check the Composer Drupal project template.
     When I run "make drupal-composer-codebase"
     Then I should get:
     """
     Initializing Drupal Composer project.
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

  
  @unit
  Scenario: Test Drumkit setup of .env and drumkit/ directory contents
     When I run "make drupal-drumkit-dir"
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
     drumkit/mk.d/20_lando.mk
     drumkit/mk.d/30_build.mk
     drumkit/mk.d/40_install.mk
     """
  
  @unit
  Scenario: Initialize lando.yml 
     # In real life this is called by interactive target init-project-drupal-user-vars
     When I run "make .lando.yml PROJECT_NAME=mydrupalsite SITE_NAME='My Drupal Site' DB_USER=drupal8 DB_NAME=drupal8 DB_PASS=drupal8 ADMIN_USER=dev ADMIN_PASS=pwd"
     Then the following files should exist:
     """
     .lando.yml
     """
     And the file ".lando.yml" should contain:
     """
     mydrupalsite
     user: drupal8
     password: drupal8
     database: drupal8
     """
  
  @unit
  Scenario: Initialize drumkit variables   
     Given I run "make drupal-drumkit-dir"     
     # In real life this is called by interactive target init-project-drupal-user-vars
     # In testing, we call `make drupal-drumkit-dir`  to ensure that drumkit/mk.d exists  
     And I run "make drumkit/mk.d/10_variables.mk PROJECT_NAME=mydrupalsite SITE_NAME='My Drupal Site' DB_USER=drupal8 DB_NAME=drupal8 DB_PASS=drupal8 ADMIN_USER=dev ADMIN_PASS=pwd"
     Then the following files should exist:
     """
     drumkit/mk.d/10_variables.mk
     """
     And the file "drumkit/mk.d/10_variables.mk" should contain:
     """
     mydrupalsite
     My Drupal Site
     drupal8
     dev
     pwd
     """

