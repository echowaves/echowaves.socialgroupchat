Given /^I should not have any convos$/ do
  Convo.destroy_all
end

Given /^"(.+)" creates "(\d+)" (.+) convos$/ do |user_name, number, privacy|
  user = User.where(:username => user_name)
  eval(number).to_i.times do |n|
    convo = Convo.new(:title => "Convo #{n}.", :privacy => "public", :created_at => n, :user => user)
    convo.save!
  end
end
