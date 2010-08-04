Given /^I should not have any convos$/ do
  Convo.destroy_all
end

Given /^"(.+)" creates "(\d+)" (.+) convos$/ do |username, number, privacy|
  user = User.where(:username => username)
  eval(number).to_i.times do |n|
    convo = Convo.new(:title => "Convo #{n}.", :privacy => "public", :created_at => n, :user => user)
    convo.save!
  end
end

Given /^"(.+)" has a "(private|public)" convo "(.+)"$/ do |username, privacy, title|
  user = User.where(:username => username)
  convo = Convo.new(:user => user, :privacy => privacy, :title => title)
  convo.save
end
