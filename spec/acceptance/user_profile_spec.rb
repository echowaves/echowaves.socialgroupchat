require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "User Profile", %q{
  In order to know more about an user
  As a user
  I want to access a page with info about the user
} do


  background do
    @user = login_new
  end


  scenario "Own profile" do
    visit "/"
    click_link "nav_profile_link"
    page.should have_content"#{@user.username}'s profile"    
  end
  
  
  scenario "Public profile" do
    @user2 = active_user
    visit users_path
    click_link @user2.username
    page.should have_content"#{@user2.username}'s profile"    
  end


  scenario "test a user follow/unfollow from a profile page stays on the same page" do
    @user2 = active_user
    visit user_path @user2

    click_link "follow"
    click_link "unfollow"
    current_path.should == user_path(@user2)
  end

  
end
