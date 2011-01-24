Feature: Convos Feature
  In order to chat
  As a registered user
  I want to be able to create a convo



  Scenario: I can access a private convo if I have an invitation
    Given a user with username "otherguy" exists
    And "otherguy" has a "private" convo "other guy's private convo"
	  And that I register and login as "testuser1" with password "testing1234"
    And I have an invitation for the "other guy's private convo" convo
    When I go to the "other guy's private convo" convo page
    Then I should be on the "other guy's private convo" convo page
    And I should see "other guy's private convo" within "#convo_header"
