@init @hugo 
Feature: Download and Install Hugo
  In order to develop a docs site with Hugo
  As a DevOps engineer
  I need to be able to install a local copy of Hugo

  Background:
    Given I bootstrap a clean Drumkit environment

  @unit
  Scenario: Hugo Dowloads right tarball for the current OS (Linux and MacOS)
    Given I run "unset DRUMKIT && source d && make -n init-project-hugo-docs-dir OS=Linux"
    Then I should get:
    """
    Download URL is 
    Linux-64bit.tar.gz
    """
    Given I run "unset DRUMKIT && source d && make -n init-project-hugo-docs-dir OS=Darwin"
    Then I should get:
    """
    Download URL is 
    macOS-64bit.tar.gz
    """
