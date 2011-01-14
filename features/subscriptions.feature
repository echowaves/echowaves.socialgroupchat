Feature: Subscriptions Feature
  In order to participate in conversations
  As a registered user
  I want to be able to subscribe/unsubscribe conversations

@selenium
  Scenario Outline: registered user creates a public/private Convo which results in subscribing to that convo as well
	  Given that I register and login as "testuser1" with password "testing1234"
	  And I should not have any convos
	  When I follow "new convo"
	  And I fill in "convo_title" with "my new convo"
	  And I choose <privacy>
	  And I press "convo_submit"
	  Then I should be on "my new convo" convo page
	  And I should see "Convo was successfully created."
     When I go to subscriptions page for user "testuser1"
	  Then I should <action> "<message>"
    Examples:
	  |   privacy                  |  action  |    message    |
	  |   "convo_privacy_public"   |  see     | my new convo  |
	  |   "convo_privacy_private"  |  see     | my new convo  |

@selenium
	Scenario: test subscriptions pagination
	  Given that I register and login as "testuser1" with password "testing1234"
	  And "testuser1" creates "21" public convos
     When I go to subscriptions page for user "testuser1"
    Then I should see "Convo 20."
	  And I should see "Next"
	  And I should see "Previous"
    And I should not see "Convo 0."
	  When I follow "Next"
	  Then I should see "Convo 0."
	  And I should not see "Convo 20."

