Feature: Signing Up
  In order to edit an account
  As a registered user
  I need to be able to edit my account

  Background:
	Given that I register and login as "testuser1" with password "testing1234"
    
  @selenium
  Scenario: Cancel my account
	When I go to the edit user link
	And I confirm a js popup on the next step
	And I follow "Cancel my account"
	Then I should not be able to login as "testuser1" with password "testing1234" 
