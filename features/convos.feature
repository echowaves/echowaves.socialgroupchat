Feature: Convos Feature
  In order to chat
  As a registered user
  I want to be able to create a convo


@selenium



  Scenario: visitor should not see the subscriptions links in the convos list
    Given a user with username "otherguy" exists
    And "otherguy" has a "public" convo "other guy's public convo"
    And I go to the convos page
    Then I should not see "subscribe" within "#convos_list"

@selenium
  Scenario: I can subscribe to a public convo from the convos list
    Given a user with username "otherguy" exists
    And "otherguy" has a "public" convo "other guy's public convo"
	  And that I register and login as "testuser1" with password "testing1234"
    When I go to the convos page
    And I follow "subscribe" within "#convos_list"
    Then I should be subscribed to the convo "other guy's public convo"

@selenium
  Scenario: I can unsubscribe from a convo from the convos list
    Given a user with username "otherguy" exists
    And "otherguy" has a "public" convo "other guy's public convo"
	  And that I register and login as "testuser1" with password "testing1234"
    And "testuser1" follow the "other guy's public convo" convo
    When I go to the convos page
    And I follow "unsubscribe" within "#convos_list"
    Then I should be unsubscribed from the convo "other guy's public convo"

  Scenario: I can access a private convo if I have an invitation
    Given a user with username "otherguy" exists
    And "otherguy" has a "private" convo "other guy's private convo"
	  And that I register and login as "testuser1" with password "testing1234"
    And I have an invitation for the "other guy's private convo" convo
    When I go to the "other guy's private convo" convo page
    Then I should be on the "other guy's private convo" convo page
    And I should see "other guy's private convo" within "#convo_header"
