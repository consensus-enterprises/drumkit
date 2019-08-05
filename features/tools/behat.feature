Feature: Install Behat locally
  In order to test a Drupal site
  As a developer
  I need to be able run Behat

  Scenario: Remove Behat
    Given I bootstrap drumkit
    When I run "make clean-behat"
    Then I should get:
      """
      Removing Behat.
      """

  @slow
  Scenario: Run 'make behat'
    Given I bootstrap drumkit
    When I run "make behat"
    Then I should get:
      """
      Downloading Behat.
      Installing Behat.
      """
    When I run "make behat"
    Then I should get:
      """
      make: Nothing to be done for
			behat
      """
