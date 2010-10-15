Given /^I should not have any convos$/ do
  Convo.destroy_all
end

Given /^"(.+)" creates "(\d+)" (.+) convos$/ do |username, number, privacy|
  user = User.where(:username => username)
  eval(number).to_i.times do |n|
    convo = Convo.make(:title => "Convo #{n}.", :privacy => "public", :created_at => n, :user => user)
  end
end

Given /^"(.+)" has a "(private|public)" convo "(.+)"$/ do |username, privacy, title|
  user = User.where(:username => username)
  convo = Convo.make(:user => user, :privacy => privacy, :title => title)
end

Given /^"([^"]*)" follow the "([^"]*)" convo$/ do |username, title|
  user = User.where(:username => username).first
  convo = Convo.where(:title => title).first
  ConvoUser.make(:user => user, :convo => convo)
end
