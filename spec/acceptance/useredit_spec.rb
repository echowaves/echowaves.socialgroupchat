require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Useredit", %q{
  In order to change user information
  As a registered user
  I want to be able to edit my profile
} do

  background do
    @user = login_new
    @user2 = active_user
    visit edit_user_registration_path
  end

  scenario "Edit user, all validations fail", :js => true do
    fill_in "user_username", :with              => @user2.username
    fill_in "user_email", :with                 => @user2.email
    fill_in "user_password", :with              => "test"
    fill_in "user_password_confirmation", :with => "test2"
    fill_in "user_current_password", :with      => "password"
    click_button "Update"
    page.should have_content "4 errors prohibited this user from being saved"
    page.should have_content "Email has already been taken"
    page.should have_content "Password doesn't match confirmation"
    page.should have_content "Password is too short (minimum is 6 characters)"
    page.should have_content "Username has already been taken"
  end

  scenario "Edit user, all validations fail should fail, but since current password is incorrect, only 1 error" do
    fill_in "user_username", :with              => @user2.username
    fill_in "user_email", :with                 => @user2.email
    fill_in "user_password", :with              => "test"
    fill_in "user_password_confirmation", :with => "test2"
    fill_in "user_current_password", :with      => "testing1234"
    click_button "Update"
    page.should have_content "1 error prohibited this user from being saved"
    page.should have_content "Current password is invalid"
  end
  
  scenario "Edit user, save with preloaded defaults" do
    click_button "Update"
    page.should have_content "1 error prohibited this user from being saved"
    page.should have_content "Current password can't be blank"    

    fill_in "user_current_password", :with      => "wrong_password"
    click_button "Update"
    page.should have_content "1 error prohibited this user from being saved"
    page.should have_content "Current password is invalid"

    fill_in "user_current_password", :with      => "password"
    fill_in "user_password", :with              => "test"
    click_button "Update"
    page.should have_content "2 errors prohibited this user from being saved"
    page.should have_content "Password doesn't match confirmation"
    page.should have_content "Password is too short (minimum is 6 characters)"
    
    fill_in "user_current_password", :with      => "password"
    click_button "Update"
    page.should have_content "You updated your account successfully."
  end

  scenario "Edit user, not supplying current password" do
    fill_in "user_username", :with              => @user2.username
    fill_in "user_email", :with                 => @user2.email
    fill_in "user_password", :with              => "test"
    fill_in "user_password_confirmation", :with => "test2"
    fill_in "user_current_password", :with      => ""
    click_button "Update"
    page.should have_content "1 error prohibited this user from being saved"
    page.should have_content "Current password can't be blank"
  end

  scenario "Edit user, cancel my account (confirm with 'ok' button)", :js => true do
    page.evaluate_script("window.alert = function(msg) { return true; }")
    page.evaluate_script("window.confirm = function(msg) { return true; }")
    click_button "Cancel my account"
    page.should have_content "Bye! Your account was successfully cancelled. We hope to see you again soon."
    login_as_user(@user)
    page.should have_content "Invalid username or password."
  end

  scenario "Edit user, cancel my account (confirm with 'cancel' button)", :js => true do
    page.evaluate_script("window.alert = function(msg) { return true; }")
    page.evaluate_script("window.confirm = function(msg) { return false; }")
    click_button "Cancel my account"

    login_as_user(@user)
    page.should have_content "Signed in successfully."
  end


end
