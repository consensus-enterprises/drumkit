Feature: Deleting files
  In order to explicitly delete files from Drumkit projects
  As a devops engineer
  I need to be able to remove files with some output.

  Background:
    Given I bootstrap a clean Drumkit environment
      And I run "touch example.txt"
      And the file "example.txt" exists

  Scenario: Remove a file.
     When I run the Drumkit command "make .remove FILES_TO_REMOVE=example.txt"
     Then I should get:
       """
       Removing file: 'example.txt'
       """
      And the file "example.txt" does not exist

  Scenario: Warn about trying to remove a file that does not exist.
    Given the file "example2.txt" does not exist
     When I run the Drumkit command "make .remove FILES_TO_REMOVE='example.txt example2.txt'"
     Then I should get:
       """
       Removing file: 'example.txt'
       Not removing non-existent file: 'example2.txt'.
       """
      And the file "example.txt" does not exist
