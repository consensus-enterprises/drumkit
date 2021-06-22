
Feature: Selfdoc for Drumkit development
  In order to document Drumkit
  As a developer
  I need to be able to add one-line descriptions that will be scraped by the help commands

  Scenario: Make sure that basic help works (with tags and parameter lists)
  Given I bootstrap Drumkit
  When I run "make help"
  Then I should get:
  """
  help-selfdoc
  Aggregate and print all short self-documentation messages from all included makefiles.
  help-category
  [category] Aggregate and print all short self-documentation messages tagged with this category in all included makefiles.
  selfdoc-howto
  Print a brief message explaining how to write self-documenting makefiles
  """
  And I run "make help-categories"
  Then I should get:
  """
  ansible
  help
  projects
  """
  And I run "make help-projects"
  Then I should get:
  """
  init-project-aegir
  init-project-ansible
  init-project-hugo-docs
  init-project-packer
  """

  Scenario: I can see documentation that only exists in the local drumkit mk.d files
  Given I bootstrap Drumkit
  When I run "make drupal-drumkit-dir"
  And I run "make help"
  Then I should get:
  """
  Start Lando containers.
  """
  And I run "cp .mk/files/test-fixtures/mock.mk drumkit/mk.d/"
  Then the following files should exist:
  """
  drumkit/mk.d/mock.mk
  """
  And I run "make help"
  Then I should get:
  """
  Some helpful text about a mock target
  """
  And I run "make help-categories"
  Then I should get:
  """
  foo
  """
  And I run "make help-foo"
  Then I should get:
  """
  make_mock_target
  Some helpful text about a mock target
  """
