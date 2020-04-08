@init @packer-ci @project @wip
Feature: Initialize projects that use Packer to manage docker images for CI.
  In order to create Packer images for my project
  As a DevOps engineer
  I need to be able to initialize my project with Packer scripts

  Scenario: Initialize a Packer CI project.
     Given I bootstrap Drumkit
      When I run "make -n init-project-packer"
      Then I should get:
      """
      No CI container registry supplied.
      Packer artifacts will be pushed to dockerhub by default.
      To change this, update CI_CONTAINER_REGISTRY's default value in drumkit/mk.d/10-variables.mk
      """
      When I run "make init-project-packer CI_CONTAINER_REGISTRY=sample.gitlab.repo/uri"
      Then I should get:
      """
      Packer artifacts will be pushed to sample.gitlab.repo/uri
      Initializing Drumkit Packer project
	    Generating Packer scripts.
      Finished initializing Drumkit Packer project
      """
      And the following files should exist:
      """
      scripts/packer/docker/10-bionic.json
      scripts/packer/docker/20-base.json
      scripts/packer/docker/30-php.json
      """
      And the file "drumkit/mk.d/10-variables.mk" should contain:
      """
      CI_CONTAINER_REGISTRY ?= sample.gitlab.repo/uri
      """
