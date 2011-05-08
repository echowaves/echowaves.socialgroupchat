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
