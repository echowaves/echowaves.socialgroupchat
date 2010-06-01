Feature: Signing Up
  In order to edit an account
  As a registered user
  I need to be able to edit my account

  Background:
	Given that I register and login as "testuser1" with password "testing1234"
    
  Scenario: Edit user, all validations fail
  	When I go to the sign out link
	Given that I register and login as "testuser2" with password "testing1234"
    When I go to the edit user link
	And I fill in "user_username" with "testuser1"
    And I fill in "user_email" with "testuser1@echowaves.com"
    And I fill in "user_password" with "test"
    And I fill in "user_password_confirmation" with "test2"
    And I fill in "user_current_password" with "testing1234"
    And I press "user_submit"
    Then I should see "4 errors prohibited this user from being saved"
    And I should see "Email is already taken"
    And I should see "Password doesn't match confirmation"
    And I should see "Password is too short (minimum is 6 characters)"
    And I should see "Username is already taken"
    
  Scenario: Edit user, not supplying current password
  	When I go to the sign out link
	Given that I register and login as "testuser2" with password "testing1234"
    When I go to the edit user link
	And I fill in "user_username" with "testuser1"
    And I fill in "user_email" with "testuser1@echowaves.com"
    And I fill in "user_password" with "test"
    And I fill in "user_password_confirmation" with "test2"
    And I fill in "user_current_password" with ""
    And I press "user_submit"
    Then I should see "1 error prohibited this user from being saved"
    And I should see "Current password can't be blank"


  @wip
  Scenario: Cancel my account
