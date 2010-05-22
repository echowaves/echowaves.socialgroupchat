Feature: Signing Up
  In order to sign up for an account
  As a guest
  I need to be able to register

  Scenario: Successful Registration
    Given I am on the sign up page
    When I fill in "user_username" with "tester"
    And I fill in "user_email" with "test@example.com"
    And I fill in "user_password" with "test1234"
    And I fill in "user_password_confirmation" with "test1234"
    And I press "user_submit"
    Then I should see "confirmation was sent to your e-mail"

  Scenario: Attempt Registration with dup username, and/or email, short password, and non matching confirmation password 
    Given test user exists
	#
    Given I am on the sign up page
    When I fill in "user_username" with "tester"
    And I fill in "user_email" with "test@example.com"
    And I fill in "user_password" with "test"
    And I fill in "user_password_confirmation" with "test2"
    And I press "user_submit"
    Then I should see "4 errors prohibited this user from being saved"
    And I should see "Email is already taken"
    And I should see "Password doesn't match confirmation"
    And I should see "Password is too short (minimum is 6 characters)"
    And I should see "Username is already taken"

  Scenario: Attempt Registration with non validating email 
    Given I am on the sign up page
    When I fill in "user_username" with "tester"
	# this email does not correspond to email format
    And I fill in "user_email" with "test@example" 
    And I fill in "user_password" with "test123"
    And I fill in "user_password_confirmation" with "test123"
    And I press "user_submit"
    Then I should see "Email is invalid"
