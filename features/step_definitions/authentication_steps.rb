Given /^I have pending confirmation$/ do
  @user = User.make(:username => "tester", :email => "test@example.com")
end

Given /^I received the email$/ do
  @user.confirmed?.should be_false
end

Given /^that a confirmed user exists$/ do
  @user = User.make(:username => "tester", :email => "test@example.com", :password => "test123")
  visit user_confirmation_path(:confirmation_token => @user.confirmation_token)
  page.should have_content("Your account was successfully confirmed")
  @user.confirm!
  visit destroy_user_session_path
end


When /^I confirm the account$/ do
  visit user_confirmation_path(:confirmation_token => @user.confirmation_token)
  page.should have_content("Your account was successfully confirmed")
  @user.confirm!
end

Then /^I should find that I am confirmed$/ do
  @user.confirmed?.should be_true
end
 
 
Given /^I am logged in$/ do
  visit new_user_session_path
  fill_in('user_username', :with => @user.username)
  fill_in('user_password', :with => @user.password)
  click_button('Sign in')
  page.should have_content('Signed in successfully')
end
