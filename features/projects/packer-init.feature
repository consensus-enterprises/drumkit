@init @packer-ci @project
Feature: Initialize projects that use Packer to manage docker images for CI.
  In order to create Packer images for my project
  As a DevOps engineer
  I need to be able to initialize my project with Packer scripts

  Background:
    Given I bootstrap Drumkit

  Scenario: Initialize a Packer CI project.
      When I run "make -n init-project-packer"
      Then I should get:
      """
      Initializing Drumkit Packer project.
      Initializing Packer JSON files and scripts.
      Finished initializing Drumkit Packer project.
      """

  Scenario: Initialize a Packer CI project.
      When I run "unset DRUMKIT && source d && make mustache && make CONTAINER_REGISTRY_URL=sample.gitlab.repo/uri CONTAINER_PROJECT_NAME=myproj init-project-packer-static drumkit/mk.d/20_ci.mk scripts/packer/scripts/myproj.sh"
      Then I should get:
      """
      Initializing Packer JSON files and scripts.
      Initializing project-specific Packer JSON file scripts/packer/json/40-myproj.json
      Initializing CI makefile.
      Initializing project specific Packer script scripts/packer/scripts/myproj.sh
      """
      And the following files should exist:
      """
      scripts/packer/json/40-myproj.json
      scripts/packer/scripts/myproj.sh
      drumkit/mk.d/20_ci.mk
      """
      And the file "drumkit/mk.d/20_ci.mk" should contain:
      """
      CONTAINER_REGISTRY_URL ?= sample.gitlab.repo/uri
      CONTAINER_PROJECT_NAME = myproj
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
