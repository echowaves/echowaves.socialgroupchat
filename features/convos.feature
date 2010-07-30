Feature: Convos Feature
  In order to chat 
  As a registered user
  I want to be able to create a convo

  Scenario: registered user creates a Convo
	Given that I register and login as "testuser1" with password "testing1234"
	And I should not have any convos
	When I follow "new convo"
	And I fill in "convo_title" with "my new convo"
	And I press "convo_submit"
	# Then I should be on convo_path
	And I should see "Convo was successfully created."
	And I should see "Title: my new convo"
    When I go to convos page
	Then I should see "my new convo"


	#   Scenario: visitor can't create a Convo
	# 
	#   Scenario: update convo is not supported
	# Given that I register and login as "testuser1" with password "testing1234"
	#  
	#   Scenario: delete convo is not supported
	# Given that I register and login as "testuser1" with password "testing1234"
