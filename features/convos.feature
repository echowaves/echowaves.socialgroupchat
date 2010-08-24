Feature: Convos Feature
  In order to chat
  As a registered user
  I want to be able to create a convo

  Scenario Outline: registered user creates a public/private Convo
	  Given that I register and login as "testuser1" with password "testing1234"
	  And I should not have any convos
	  When I follow "new convo"
	  And I fill in "convo_title" with "my new convo"
	  And I choose <privacy>
	  And I press "convo_submit"
	  Then I should be on "my new convo" convo page
	  And I should see "Convo was successfully created."
    When I go to convos page
	  Then I should <action> "my new convo"
	  # make sure that non registerred user is still can see or not see the convo
	  When I go to the sign out link
	  And I go to convos page
	  Then I should <action> "<message>"
    Examples:
	  |   privacy                  |  action  |    message    |
	  |   "convo_privacy_public"   |  see     | my new convo  |
	  |   "convo_privacy_private"  |  not see | my new convo  |

	Scenario: test convos pagination
	  Given that I register and login as "testuser1" with password "testing1234"
	  And "testuser1" creates "21" public convos
	  When I go to convos page
    Then I should see "Convo 20."
	  And I should see "Next"
	  And I should see "Previous"
    And I should not see "Convo 0."
	  When I follow "Next"
	  Then I should see "Convo 0."
	  And I should not see "Convo 20."

    Scenario: visitor can't create a Convo
	  When I go to home page
	  Then I should not see "new convo"
	  And I go to create new convo page
	  Then I should see "You need to sign in or sign up before continuing."

	@wip
	Scenario: non invited user cannot access private convo_privacy_private

	@wip
	Scenario: make sure that a user who is not made part of the private convo cannot access it
