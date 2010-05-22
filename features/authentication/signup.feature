Feature: Signing Up
  In order to sign up for an account
  As a guest
  I need to be able to register

  Scenario: Registration
    Given I am on the sign up page
    When I fill in "user_username" with "tester"
    And I fill in "user_email" with "test@example.com"
    And I fill in "user_password" with "test1234"
    And I fill in "user_password_confirmation" with "test1234"
    And I press "user_submit"
    Then I should see "confirmation was sent to your e-mail"
