require File.dirname(__FILE__) + '/acceptance_helper'

feature "Forgot password", %q{
  In order to login
  As a user
  When I have forgotten my password
  I want to reset it } do

  background do
    @user = User.make(:username => "tester", :email => "test@example.com", :password => "test123")
    visit "/users/confirmation?confirmation_token=#{@user.confirmation_token}"
    page.should have_content("Your account was successfully confirmed")
    @user.confirm!
    visit "/users/sign_out"
  end

  scenario "Reset password request" do
    visit "/users/password/new"
    fill_in "user_email", :with => "test@example.com"
    click_button('Send me reset password instructions')
    page.should have_content("You will receive an email with instructions about how to reset your password")
    visit "/users/password/new"
    fill_in "user_email", :with => "bad@example.com"
    click_button('Send me reset password instructions')
    page.should have_content("Email not found")
  end

  scenario "Reset password confirmation" do
    @user.send_reset_password_instructions
    visit "/users/password/edit?reset_password_token=#{@user.reset_password_token}"
    page.should have_content("Change your password")
    fill_in 'user_password', :with => 'test1234'
    fill_in 'user_password_confirmation', :with => 'test1234'
    click_button('Change my password')
    page.should have_content('Your password was changed successfully')
  end

end
