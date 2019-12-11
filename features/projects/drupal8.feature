@init @drupal8 @project
Feature: Initialize Drupal 8 projects with Lando.
  In order to start a new Drupal 8 project in a Lando environment
  As a Drupal Developer
  I need to be able to initialize Drupal 8 projects

  Scenario: Initialize a Drupal 8 project.
    Given I bootstrap Drumkit
      And I run "make -n init-project-drupal8"
     Then I should get:
     """
     Initializing Drumkit Drupal 8 project
     Installing python dependencies so that Drumkit can use ansible and jinja2.
     Installing PHP dependencies.
     Installing Behat.
     """
