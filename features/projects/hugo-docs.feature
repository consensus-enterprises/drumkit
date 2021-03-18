@init @hugo @project
Feature: Initialize Hugo Docs Projects
  In order to develop a docs site with Hugo
  As a DevOps engineer
  I need to be able to initialize Hugo projects

  Background:
    Given I bootstrap a clean Drumkit environment

  @unit
  Scenario: Indivdual targets generate correct files
    When I run "unset DRUMKIT && source d && make docs"
    Then I should get:
    """
    Hugo Static Site Generator
    Congratulations! Your new Hugo site    
    """
    And the following files should exist:
    """
    docs/archetypes
    docs/content
    docs/data
    docs/layouts
    docs/static
    """
    And I run "make docs/config.yaml"
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
    And I run "make docs/layouts/index.json"
    Then I should get:
    """
    Initializing search index.json.
    """
    And the following files should exist:
    """
    docs/layouts/index.json
    """
    And I run "make docs/themes/learn"
    Then I should get:
    """
    Installing learn theme
    """
    And the following files should exist:
    """
    docs/themes/learn
    """
    And the file ".gitmodules" should contain:
    """
    submodule "docs/themes/learn"
    path = docs/themes/learn
    url = https://github.com/matcornic/hugo-theme-learn.git
    """
    And I run "make .gitlab-ci.yml"
    Then the following files should exist:
    """
    .gitlab-ci.yml
    """

  @wip
  Scenario: After the project is initialized, I can add the first content file
  Given [The docs folder exists and hugo is installed]
    When I run "make docs/content/_index.md"
    Then the following files should exist:
    """
    docs/content/_index.md
    """
    And the file "docs/content/_index.md" should contain:
    """
    draft: true
    """

  @wip
  Scenario: Once the project is installed, I can run CI tests on the project using gitlab-runner


  @overall
  Scenario: Initialize a Hugo Docs project.
     When I run "unset DRUMKIT && source d && make init-project-hugo-docs"
     Then I should get:
     """
     Initializing Hugo Docs project
     Downloading the 
     Your new docs site has been added, configuration instructions are in docs/config.yaml
     """
     And the following files should exist:
     """
     docs/archetypes
     docs/content
     docs/data
     docs/layouts
     docs/static
     docs/config.yaml
     docs/layouts/index.json
     docs/themes/learn
     docs/content/_index.md
     .gitlab-ci.yml
     """


