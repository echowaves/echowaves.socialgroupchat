require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Login Forgot Password", %q{
  In order to login
  As a user
  I want to be able to reset my forgot password
} do

  background do
    @user = User.make(:username => "tester", :email => "test@example.com", :password => "test123")
    visit user_confirmation_path(:confirmation_token => @user.confirmation_token)
    page.should have_content("Your account was successfully confirmed")
    @user.confirm!
    visit destroy_user_session_path
  end

  scenario "Reset password request" do
    visit new_user_password_path
    fill_in "user_email", :with => "test@example.com"
    click_button "Send me reset password instructions"
    page.should have_content("You will receive an email with instructions about how to reset")
    visit new_user_password_path
    fill_in "user_email", :with => "bad@example.com"
    click_button "Send me reset password instructions"
    page.should have_content("Email not found")
  end

  scenario "Reset password confirmation" do
    @user.send_reset_password_instructions
    visit edit_user_password_path(:reset_password_token => @user.reset_password_token)
    fill_in 'user_password', :with => 'test1234'
    fill_in 'user_password_confirmation', :with => 'test1234'
    click_button('Change my password')
    page.should have_content('Your password was changed successfully')
  end
end
