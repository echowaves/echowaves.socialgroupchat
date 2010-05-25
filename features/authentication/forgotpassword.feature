Feature: Forgot password
  In order to login
  As a user
  When I have forgotten my password
  I should be able to reset it

  Background:
    Given that a confirmed user exists

  Scenario Outline: Reset password request
    Given I am on the forgotten password page
    When I fill in "user_email" with <email>
    And I press "Send me reset password instructions"
    Then I should <action>
    Examples:
      |         email         |                                       action                                       |
      | "test@example.com"    | see "You will receive an email with instructions about how to reset your password" |
      | "bad@example.com"     | see "Email not found"                                                              |


  Scenario: Reset password confirmation
    Given that I have reset my password
    When I follow the reset password link in my email
    Then I expect to be able to reset my password

  