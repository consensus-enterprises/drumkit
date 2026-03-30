@init @packer-ci @project
Feature: Initialize projects that use Packer to manage docker images for CI.
  In order to create Packer images for my project
  As a DevOps engineer
  I need to be able to initialize my project with Packer scripts

  Background:
    Given I bootstrap Drumkit

  Scenario: Initialize a Packer CI project.
      When I run "make -n init-project-packer PROJECT_CONTAINER_NAME=myproj PROJECT_CONTAINER_REGISTRY_URL=sample.gitlab.repo/uri"
      Then I should get:
      """
      Initializing Drumkit Packer project.
      Please provide the following information to initialize your Packer scripts:
      make -s init-project-packer-vars init-project-packer-static PROJECT_CONTAINER_NAME=myproj PROJECT_CONTAINER_REGISTRY_URL=sample.gitlab.repo/uri
      Finished initializing Drumkit Packer project.
      """

  Scenario: Initialize a Packer CI project.
      When I run "unset DRUMKIT && source d && make PROJECT_CONTAINER_REGISTRY_URL=sample.gitlab.repo/uri PROJECT_CONTAINER_NAME=myproj init-project-packer"
      Then I should get:
      """
      No .env file found. Consider copying .env.tmpl and adding GitLab credentials.
      Generate a Personal Access Token here: https://gitlab.com/-/user_settings/personal_access_tokens
      Initializing Drumkit Packer project.
      Please provide the following information to initialize your Packer scripts:
      Initializing CI makefile.
      Initializing project specific Packer script scripts/packer/scripts/myproj.sh
      Initializing drumkit/bootstrap.d/01_environment.sh.
      Initializing .env.tmpl.
      Initializing Packer JSON files and scripts.
      Initializing project-specific Packer JSON file scripts/packer/docker/myproj.json
      Finished initializing Drumkit Packer project.
      """
      And the following files should exist:
      """
      scripts/packer/docker/myproj.json
      scripts/packer/scripts/myproj.sh
      drumkit/bootstrap.d/01_environment.sh
      drumkit/mk.d/20_ci.mk
      .env.tmpl
      """
      And the file "drumkit/mk.d/20_ci.mk" should contain:
      """
      CONTAINER_REGISTRY_URL = sample.gitlab.repo/uri
      PROJECT_CONTAINER_NAME = myproj
      """
      Then I run "make clone"
      And I should get:
      """
      Cloning a fresh copy of our code
      """
      Then I run "make clone"
      And I should get:
      """
      up to date, skipping reclone.
      """
      Then I run "make -n ci-images"
      And I should get:
      """
      Building packer images for CI.
      Using project name: myproj
      Using container registry: sample.gitlab.repo/uri
     """
