require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Session", %q{
  In order to use the site
  As a registered user
  I want to be able to login and logout
} do

  background do
    @user = active_user
  end


  scenario "Logging out" do
    login_as_user(@user)
    visit destroy_user_session_path
    page.should have_content("Signed out successfully.")
  end


  # Scenario Outline: Logging in
  #   Given I am on the login page
  #   When I fill in "user_username" with <username>
  #   And I fill in "user_password" with <password>
  #   And I press "user_submit"
  #   Then I should <action>
  #   Examples:
  #     |   username  |  password     |              action             |
  #     |   "tester"  |  "test123"    | see "Signed in successfully"    |
  #     |   "tester1" |  "test1234"   | see "Invalid username or password" |
  #     |   "tester"  |  "test12345"  | see "Invalid username or password" |

  scenario "Loggin in successfully" do
    login_as_user(@user)
    page.should have_content("Signed in successfully.")
  end

  scenario "Loggin in with wrong username" do
    login("random", "changeme")
    page.should have_content("Invalid username or password.")
  end

  scenario "Loggin in with wrong password"  do
    login(@user.username, "change_me_wrong")
    page.should have_content("Invalid username or password.")
  end
  
end
