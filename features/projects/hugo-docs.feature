@init @hugo @project
Feature: Initialize Hugo Docs Projects
  In order to develop a docs site with Hugo
  As a DevOps engineer
  I need to be able to initialize Hugo projects

  Background:
    Given I bootstrap a clean Drumkit environment

  @overall
  Scenario: Initialize a Hugo Docs project.
     When I run "make -n init-project-hugo-docs"
     Then I should get:
      """
      Initializing Hugo Docs project
      Downloading the 
      Your new docs site is initialized, please edit docs/config.yaml to fill in site details

      """

  @unit
  Scenario: Initialize config.yaml file
    When I run "unset DRUMKIT && source d && make docs/config.yaml GITLAB_GROUP=mygroup GITLAB_PROJECT_NAME=myproject"
    Then I should get:
    """
    Initializing config.yaml
    """
    And the following files should exist:
    """
    docs/config.yaml
    """
    And the file "docs/config.yaml" should contain:
    """
    baseUrl: "http://mygroup.gitlab.io/myproject/
    editURL: "https://gitlab.com/mygroup/myproject/tree/master/docs/content/"
    """ 

  @unit
  Scenario: Initialize Hugo Docs Directory & Search Index
    Given I run "unset DRUMKIT && source d && make init-project-hugo-docs-dir"
    Then I should get:
    """
    Hugo Static Site Generator
    Congratulations! Your new Hugo site
    """
    And the following files should exist:
    """
    docs/themes/learn
    docs/archetypes
    docs/config.toml
    docs/content
    docs/data
    docs/layouts
    docs/static
    """
    When I run "make hugo-docs-search-index"
    Then I should get:
    """
    Initializing search index.json
    """
    And the following files should exist:
    """
    docs/layouts/index.json
    """
