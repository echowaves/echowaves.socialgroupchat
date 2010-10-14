Given /^a user with username "([^"]*)" exists$/ do |username|
  User.make(:username => username)
end
