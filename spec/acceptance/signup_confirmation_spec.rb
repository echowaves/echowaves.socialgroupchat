require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Signup Confirmation", %q{
  In order to activate my account
  As a user
  I want to be able to confirm
} do

  background do
    @user = User.make(:username => "tester", :email => "test@example.com")
  end

  scenario "Confirmation" do  
    @user.should_not be_confirmed
    puts user_confirmation_path(:confirmation_token => @user.confirmation_token)
    visit user_confirmation_path(:confirmation_token => @user.confirmation_token)
    page.should have_content("Your account was successfully confirmed")
    # @user.confirm!
    @user.reload
    @user.should be_confirmed
  end

  scenario "Resend confirmation instructions" do
    visit new_user_confirmation_path
    fill_in "user_email", :with => "test@example.com"
    click_button "Resend confirmation instructions"
    page.should have_content("You will receive an email with instructions about how to confirm your account")
    visit new_user_confirmation_path
    fill_in "user_email", :with => "bad@example.com"
    click_button "Resend confirmation instructions"
    page.should have_content("Email not found")
  end
end
