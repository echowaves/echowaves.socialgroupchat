Feature:
  In order activate my account
  As a user
  I want to be able to confirm

  Background:
  	Given I have pending confirmation

  Scenario: Confirmation
    Given I received the email
    When I confirm the account
    Then I should find that I am confirmed
