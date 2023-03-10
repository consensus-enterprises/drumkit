Feature: Checking for variables
  In order to create Drumkit commands with inputs that have no default value
  As a devops engineer
  I need to be able to check whether a variable is set and fail if not.

  Background:
    Given I bootstrap a clean Drumkit environment

  Scenario: Fail when variable is not set.
	 When I fail to run "make .checkvar-FOOBAR"
     Then I should get:
      """
      Variable FOOBAR not set
      """

	# See https://gist.github.com/brimston3/fc43658bdb6882ed13d942fa584dd2de
  Scenario: Fail when variable is not set even if a file with the same name exists.
    Given I run "touch .checkvar-BARBAAZ"
      And the file ".checkvar-BARBAAZ" exists
	 When I fail to run "make .checkvar-BARBAAZ"
     Then I should get:
      """
      Variable BARBAAZ not set
      """

  Scenario: Do not fail when variable is set.
	 When I run "make .checkvar-BAAZQUUX BAAZQUUX=1"
     Then I should not get:
      """
      Variable BAAZQUUX not set
      """


