require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Users List", %q{
  In order to view a list of existing users
  As a guest or user
  I want to access a page with this list
} do

  scenario "Navigate to the users list" do
    @user = User.make(:username => "foo", :email => "foo@example.com")
    @user = User.make(:username => "bar", :email => "bar@example.com")
    visit root_path
    click_link("nav_users_link")
    page.should have_content "Users List"
    page.should have_content "foo"
    page.should have_content "bar"
  end
end
