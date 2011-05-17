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

