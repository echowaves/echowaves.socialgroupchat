Feature: User profile
In order to know more about an user
I will need to access a page with info about the user

  Scenario: Public profile
    Given a user with username "crossblaim" exists
    And a user with username "dmitry" exists
    When I go to the users page
    And I follow "crossblaim"
    Then I should see "crossblaim's profile"

  Scenario: Own profile
    Given that I register and login as "crossblaim" with password "pass123"
    When I go to the home page
    When I follow "nav_profile_link"
    Then I should see "crossblaim's profile"



