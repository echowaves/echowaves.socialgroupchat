Feature: Messages Feature
  In order to chat 
  As a registered user
  I want to be able to post a message to existing convo

@wip
@selenium
  Scenario: registered user can post a message to 
    Given that I register and login as "testuser1" with password "testing1234"
	And "testuser1" has a "public" convo "want to start talking"
    And I am on "want to start talking" convo page
    And I am on messages page for "want to start talking" convo
	And I 
