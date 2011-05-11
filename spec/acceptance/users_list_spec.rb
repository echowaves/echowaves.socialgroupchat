require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Users List", %q{
  In order to view a list of existing users
  As a guest or user
  I want to access a page with this list
} do

  scenario "Navigate to the users list" do
    @user = Factory(:user, :username => "foo", :email => "foo@example.com")
    @user = Factory(:user, :username => "bar", :email => "bar@example.com")
    visit root_path
    click_link("nav_users_link")
    page.should have_contentcontent "Users List"
    page.should have_content "foo"
    page.should have_content "bar"
  end

  scenario "test users pagination" do
    26.times do |i|
      Factory(:user, :username => "User-#{i}")
    end
    visit users_path
    page.should have_content "User-25"

    page.should have_content "Next"
    page.should have_no_content "Prev"
    page.should have_no_content "User-0"
    click_link "Next"
    page.should have_content "User-0"
    page.should_not have_content "User-25"
    page.should have_no_content "Next"
    page.should have_content "Prev"
  end
  
  scenario "test a user follow/unfollow from a users list stays on the same page" do
    @user = login_new
    100.times do |i|
      Factory(:user, :username => "User-#{i}")
    end
    visit users_path
    click_link "Next"
    click_link "Next"
    page.should have_content "User-49"
    click_link "follow"
    page.should have_content "User-49"
    click_link "unfollow"
    page.should have_content "User-49"
    current_path.should == users_path
  end
  

end
