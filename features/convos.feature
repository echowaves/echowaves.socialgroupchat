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

  Scenario: owner can visit his own private convos
	  Given that I register and login as "testuser1" with password "testing1234"
    And "testuser1" has a "private" convo "my private convo"
    And I go to "my private convo" convo page
    Then I should be on the "my private convo" convo page
    And I should see "my private convo" within "#convo_header"

  Scenario: owner can visit his own public convos
	  Given that I register and login as "testuser1" with password "testing1234"
    And "testuser1" has a "public" convo "my public convo"
    And I go to "my public convo" convo page
    Then I should be on the "my public convo" convo page
    And I should see "my public convo" within "#convo_header"

  Scenario: user can't access a private convo he don't follows
	  Given that I register and login as "testuser1" with password "testing1234"
    And a user with username "otherguy" exists
    And "otherguy" has a "private" convo "other guy's private convo"
    And I go to "other guy's private convo" convo page
    Then I should be on the convos page
    And I should see "Sorry but this convo is private"

  Scenario: user can access a public convo
	  Given that I register and login as "testuser1" with password "testing1234"
    And a user with username "otherguy" exists
    And "otherguy" has a "public" convo "other guy's public convo"
    And I go to "other guy's public convo" convo page
    Then I should be on the "other guy's public convo" convo page
    And I should see "other guy's public convo" within "#convo_header"

  Scenario: user can access a private convo he follows
	  Given that I register and login as "testuser1" with password "testing1234"
    And a user with username "otherguy" exists
    And "otherguy" has a "private" convo "other guy's private convo"
    And "testuser1" follow the "other guy's private convo" convo
    And I go to "other guy's private convo" convo page
    Then I should be on the "other guy's private convo" convo page
    And I should see "other guy's private convo" within "#convo_header"

  Scenario: visitor can access public convo
    Given a user with username "otherguy" exists
    And "otherguy" has a "public" convo "other guy's public convo"
    And I go to the "other guy's public convo" convo page
    Then I should be on the "other guy's public convo" convo page
    And I should see "other guy's public convo" within "#convo_header"

  Scenario: visitor can't access private convo
    Given a user with username "otherguy" exists
    And "otherguy" has a "private" convo "other guy's private convo"
    And I go to the "other guy's private convo" convo page
    Then I should be on the convos page
    And I should see "Sorry but this convo is private"
