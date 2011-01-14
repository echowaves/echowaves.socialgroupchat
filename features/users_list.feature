Feature: Users list
In order to view a list of existing users
I will need to access a page with this list

@selenium
  Scenario: Click on the users icon
    Given a user with username "crossblaim" exists
    And a user with username "dmitry" exists
    When I go to the home page
    And I follow "nav_users_link"
    Then I should see "Users List"
    And I should see "crossblaim"
    And I should see "dmitry"
