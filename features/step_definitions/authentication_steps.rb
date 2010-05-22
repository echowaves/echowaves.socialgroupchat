Given /^test user exists$/ do
  User.make(:username => "tester", :email => "test@example.com")
end
