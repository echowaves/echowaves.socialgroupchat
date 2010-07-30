Feature: Confirmation Feature
  In order activate my account
  As a user
  I want to be able to confirm

  Background:
  	Given I have pending confirmation

  Scenario: Confirmation
    Given I received the email
    When I confirm the account
    Then I should find that I am confirmed

  Scenario Outline: Resend confirmation instructions
    Given I am on the resend confirmation page
    When I fill in "user_email" with <email>
    And I press "Resend confirmation instructions"
	Then I should <action>
    Examples:
      |         email         |                                       action                                        |
      | "test@example.com"    | see "You will receive an email with instructions about how to confirm your account" |
      | "bad@example.com"     | see "Email not found"                                                               |
