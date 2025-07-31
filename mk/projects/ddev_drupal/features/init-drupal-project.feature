@init @drupal @project
Feature: Initialize Drupal projects with DDEV.
  In order to start a new Drupal project in a DDEV environment
  As a Drupal Developer
  I need to be able to initialize Drupal projects

  Background:
    Given I bootstrap a clean Drumkit environment

  Scenario: Initialize a Drupal project without a PROJECT_NAME or SITE_NAME should produce an error
    When I fail to run "make init-project-drupal-user-vars"
    Then I should get:
    """
    Variable PROJECT_NAME not set
    """
    When I fail to run "make init-project-drupal-user-vars PROJECT_NAME=hummus"
    Then I should get:
    """
    Variable SITE_NAME not set
    """
# It's tricky to run this in tests because it calls `ddev` commands, which #are not available inside the container where the command is being run.
# @TODO: Figure out a way to validate that this works with the variables present?
#    @wip
#    When I run "make init-project-drupal-user-vars PROJECT_NAME=hummus SITE_NAME='Hummus is Yummus'"
#    Then I should not get:
#    """
#    Variable PROJECT_NAME not set
#    Variable SITE_NAME not set
#    """
#     And I should get:
#    """
#    foo
#    """

  Scenario: Initialize a Drupal project.
     When I run "make -n init-project-drupal-deps"
     Then I should get:
     """
     Ensuring Docker is installed.
     Ensuring DDEV is installed.
     """
     When I run "make -n init-project-drupal"
     Then I should get:
     """
     Initializing Drupal Composer project.
     You can spin up your project using the following commands
     """

  # We can't do this because it calls DDEV inside the web container
  @slow @wip
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
     drumkit/bootstrap.d/50_ddev.sh
     """
     And the file ".env" should contain:
     """
	   COMPOSER_CACHE_DIR=tmp/composer-cache/
     """
     And the file "drumkit/bootstrap.d/50_ddev.sh" should contain:
     """
	   export $(cat .env | xargs)
     """
     And the following files should exist:
     """
     drumkit/mk.d/20_ddev.mk
     drumkit/mk.d/30_build.mk
     drumkit/mk.d/40_install.mk
     drumkit/mk.d/50_backup.mk
     drumkit/mk.d/60_test.mk
     """
  
  # We can't really test this in the web container because it relies on calling ddev commands.
  @unit @wip
  Scenario: Initialize DDEV config file
     When I run "make init-project-drupal-user-vars PROJECT_NAME=hummus SITE_NAME='Hummus is Yummus'"
     Then I should get:
     """
     Initializing DDEV config file
     """
     And the following files should exist:
     """
     .ddev/config.yaml
     """
     And the file ".ddev/config.yaml" should contain:
     """
     name: hummus
     """
  
  @unit
  Scenario: Initialize drumkit variables file   
     When I run "unset DRUMKIT && source d && make mustache drumkit/mk.d/10_variables.mk PROJECT_NAME=hummus SITE_NAME='Hummus is Yummus'"
     Then I should get:
     """
     Initializing drumkit variables file.
     """
     Then the following files should exist:
     """
     drumkit/mk.d/10_variables.mk
     """
     And the file "drumkit/mk.d/10_variables.mk" should contain:
     """
     hummus
     Hummus is Yummus
     dev
     pwd
     """
