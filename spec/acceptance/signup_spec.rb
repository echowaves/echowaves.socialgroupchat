require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Signup", %q{
  In order to sign up for an account
  As a guest
  I want to be able to register
} do

  scenario "Sucessful registration" do
    visit new_user_registration_path
    fill_in "user_username", :with => "tester"
    fill_in "user_email", :with => "test@example.com"
    fill_in "user_password", :with => "test1234"
    fill_in "user_password_confirmation", :with => "test1234"
    click_button "user_submit"
    page.should have_content "You have signed up successfully. However, we could not sign you in because your account is unconfirmed."
  end

  scenario "Attempt registration with dup username, and/or email, short password, and not matching confirmation password" do
    @user = User.make(:username => "tester", :email => "test@example.com")
    visit new_user_registration_path
    fill_in "user_username", :with => "tester"
    fill_in "user_email", :with => "test@example.com"
    fill_in "user_password", :with => "test1"
    fill_in "user_password_confirmation", :with => "test2"
    click_button "user_submit"
    page.should have_content "4 errors prohibited this user from being saved"
    page.should have_content "Email is already taken"
    page.should have_content "Password doesn't match confirmation"
    page.should have_content "Password is too short (minimum is 6 characters)"
    page.should have_content "Username is already taken"
  end

  scenario "Attempt registration with non validating email" do
    visit new_user_registration_path
    fill_in "user_username", :with => "tester"
    fill_in "user_email", :with => "test@example"
    fill_in "user_password", :with => "test1234"
    fill_in "user_password_confirmation", :with => "test1234"
    click_button "user_submit"
    page.should have_content "Email is invalid"
  end
end
