@init @packer-ci @project
Feature: Initialize projects that use Packer to manage docker images for CI.
  In order to create Packer images for my project
  As a DevOps engineer
  I need to be able to initialize my project with Packer scripts

  Background:
    Given I bootstrap Drumkit
      And I run "cp .mk/files/packer/drumkit-packer.conf.test .drumkit-packer.conf"

  Scenario: Initialize a Packer CI project.
      When I run "make init-project-packer"
      Then I should get:
      """
      Initializing Drumkit Packer project.
      Initializing CI makefile.
      Initializing Packer JSON files and scripts.
      Initializing project specific Packer script scripts/packer/scripts/myproj.sh
      Initializing project-specific Packer JSON file scripts/packer/json/40-myproj.json
      Finished initializing Drumkit Packer project.
      """
      And the following files should exist:
      """
      scripts/packer/scripts/apt.sh
      scripts/packer/scripts/cleanup.sh
      scripts/packer/scripts/php.sh
      scripts/packer/scripts/purge-extra-packages.sh
      scripts/packer/scripts/python.sh
      scripts/packer/scripts/utils.sh
      scripts/packer/scripts/myproj.sh
      scripts/packer/json/10-bionic.json
      scripts/packer/json/20-base.json
      scripts/packer/json/30-php.json
      scripts/packer/json/40-myproj.json
      """
      And the file "drumkit/mk.d/20-ci.mk" should contain:
      """
      CONTAINER_REGISTRY_URL ?= sample.gitlab.repo/uri
      CONTAINER_PROJECT_NAME = myproj
      """
      And the following files should not exist:
      """
      .drumkit-packer.conf
      """ 

