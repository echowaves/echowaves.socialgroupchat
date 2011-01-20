require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Useredit", %q{
  In order to change user information
  As a registered user
  I want to be able to edit my profile
} do

  background do
    @user = active_user
    login_as_user(@user)
    @user2 = active_user
    visit edit_user_registration_path
  end

  scenario "Edit user, all validations fail" do
    fill_in "user_username", :with              => @user2.username
    fill_in "user_email", :with                 => @user2.email
    fill_in "user_password", :with              => "test"
    fill_in "user_password_confirmation", :with => "test2"
    fill_in "user_current_password", :with      => "password"
    click_button "user_submit"
    page.should have_content "4 errors prohibited this user from being saved"
    page.should have_content "Email is already taken"
    page.should have_content "Password doesn't match confirmation"
    page.should have_content "Password is too short (minimum is 6 characters)"
    page.should have_content "Username is already taken"
  end

  scenario "Edit user, all validations fail should fail, but since current password is incorrect, only 1 error" do
    fill_in "user_username", :with              => @user2.username
    fill_in "user_email", :with                 => @user2.email
    fill_in "user_password", :with              => "test"
    fill_in "user_password_confirmation", :with => "test2"
    fill_in "user_current_password", :with      => "testing1234"
    click_button "user_submit"
    page.should have_content "1 error prohibited this user from being saved"
    page.should have_content "Current password is invalid"
  end
  
  scenario "Edit user, save with preloaded defaults" do
    click_button "user_submit"
    page.should have_content "1 error prohibited this user from being saved"
    page.should have_content "Current password can't be blank"    

    fill_in "user_current_password", :with      => "wrong_password"
    click_button "user_submit"
    page.should have_content "1 error prohibited this user from being saved"
    page.should have_content "Current password is invalid"

    fill_in "user_current_password", :with      => "password"
    fill_in "user_password", :with              => "test"
    click_button "user_submit"
    page.should have_content "2 errors prohibited this user from being saved"
    page.should have_content "Password doesn't match confirmation"
    page.should have_content "Password is too short (minimum is 6 characters)"
    
    fill_in "user_current_password", :with      => "password"
    click_button "user_submit"
    page.should have_content "You updated your account successfully."
  end

  scenario "Edit user, not supplying current password" do
    fill_in "user_username", :with              => @user2.username
    fill_in "user_email", :with                 => @user2.email
    fill_in "user_password", :with              => "test"
    fill_in "user_password_confirmation", :with => "test2"
    fill_in "user_current_password", :with      => ""
    click_button "user_submit"
    page.should have_content "1 error prohibited this user from being saved"
    page.should have_content "Current password can't be blank"
  end

  scenario "Edit user, cancel my account" do
    
    # test that cancel button cancels the action and the ok button cancels the account
    
  #     
  # And I confirm a js popup on the next step
  # And I follow "Cancel my account"
  # Then I should not be able to login as "testuser1" with password "testing1234" 
  end

end
