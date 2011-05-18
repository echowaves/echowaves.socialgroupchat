# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)


require "factories"

@dmitry = Factory( :user, username: "dmitry", 
                    password: "password", email: "dmitry@example.com", confirmed_at: Time.new)
@guest  = Factory( :user, username: "guest", 
                    password: "password", email: "guest@example.com", confirmed_at: Time.new)
@visitor = Factory( :user, username: "visitor", 
                    password: "password", email: "visitor@example.com", confirmed_at: Time.new)

40.times do |i| 
  a_convo = Factory(:convo, :title => "repeatable_#{i}", :owner => @dmitry, :privacy_level => 1)
  a_convo.subscribe @dmitry
end

a_convo_with_subscribers = Factory(:convo, :title => "convo with some subs", :owner => @dmitry, :privacy_level => 1)
100.times do |i| 
  a_user = Factory( :user, username: "user_#{i}", 
                      password: "password", email: "user_#{i}@example.com", confirmed_at: Time.new)
  a_convo_with_subscribers.subscribe a_user
end

@dmitry.follow @guest
@dmitry.follow @visitor

@guest.follow   @dmitry
@visitor.follow @dmitry


Factory(:convo, :title => "dmitry's friends", :owner => @dmitry, :privacy_level => 0)
Factory(:convo, :title => "dmitry's social", :owner => @dmitry, :privacy_level => 1)
Factory(:convo, :title => "dmitry's diary", :owner => @dmitry, :privacy_level => 1, :read_only => true)

Factory(:convo, :title => "guest testing", :owner => @guest, :privacy_level => 1)
Factory(:convo, :title => "visitor testing", :owner => @visitor, :privacy_level => 1)
Factory(:convo, :title => "cofidential guest", :owner => @guest, :privacy_level => 0, :read_only => true)

