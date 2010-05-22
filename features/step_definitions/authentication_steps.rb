Given /^I have pending confirmation$/ do
  @user = User.make(:username => "tester", :email => "test@example.com")
end

Given /^I received the email$/ do
  @user.confirmed?.should be_false
end


When /^I confirm the account$/ do
  visit user_confirmation_path(:confirmation_token => @user.confirmation_token)
  page.should have_content("Your account was successfully confirmed")
  @user.confirm!
end

Then /^I should find that I am confirmed$/ do
  @user.confirmed?.should be_true
end
 
