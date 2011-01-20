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

  scenario "Loggin in successfully" do
    login_as_user(@user)
    page.should have_content("Signed in successfully.")
  end

  scenario "Loggin in with wrong username" do
    login("random")
    page.should have_content("Invalid username or password.")
  end

  scenario "Loggin in with wrong password"  do
    login(@user.username, "password_wrong")
    page.should have_content("Invalid username or password.")
  end
  
end
