Feature: Session handling
  In order to use the site
  As a registered user
  I need to be able to login and logout

  Background:
    Given that a confirmed user exists

  Scenario Outline: Logging in
    Given I am on the login page
    When I fill in "user_username" with <username>
    And I fill in "user_password" with <password>
    And I press "user_submit"
    Then I should <action>
    Examples:
      |   username  |  password     |              action             |
      |   "tester"  |  "test123"    | see "Signed in successfully"    |
      |   "tester1" |  "test1234"   | see "Invalid username or password" |
      |   "tester"  |  "test12345"  | see "Invalid username or password" |

  Scenario: Logging out
    Given I am logged in
    When I go to the sign out link
    Then I should see "Signed out successfully"
