Given /^I should not have any convos$/ do
  Convo.destroy_all
end

Given /^"(.+)" creates "(\d+)" (.+) convos$/ do |username, number, privacy|
  user = User.where(:username => username).first
  eval(number).to_i.times do |n|
    Convo.make(:title => "Convo #{n}.", :privacy => "public",
               :created_at => n, :user => user)
  end
end

Given /^"(.+)" has a "(private|public)" convo "(.+)"$/ do |username, privacy, title|
  user = User.where(:username => username).first
  Convo.make(:user => user, :privacy => privacy, :title => title)
end

Given /^"([^"]*)" follow the "([^"]*)" convo$/ do |username, title|
  user = User.where(:username => username).first
  convo = Convo.where(:title => title).first
  Subscription.make(:user => user, :convo => convo)
end

Then /^I should be subscribed to the convo "([^"]*)"$/ do |title|
  convo = Convo.where(:title => title).first
  convo.users.should include @user
end

Then /^I should be unsubscribed from the convo "([^"]*)"$/ do |title|
  convo = Convo.where(:title => title).first
  convo.users.should_not include @user
end

Given /^I have an invitation for the "([^"]*)" convo$/ do |title|
  convo = Convo.where(:title => title).first
  convo.invite_user(@user)
end
