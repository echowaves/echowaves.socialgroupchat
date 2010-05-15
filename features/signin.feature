Feature: Sign In
  As a registered user
  I want to sign in 
  So that I have secure access to every feature on the site

  @wip
  Scenario: Sign Up a new user
    Given not signed in
	When I goto the SignUp page
	And I fill in "username" with "testuser"
	And I fill in "email" with "testuser@echowaves.com"
	And I fill in "password" with "testing"
	And I fill in "password_confirm" with "testing"
	And I press "Sign Up"
	Then I should see "email sent"
	And I should receive activation email
	When I click on activation link
	Then I should be SignedIn
	And I should be on "EditUser" page



