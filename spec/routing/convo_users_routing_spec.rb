require 'spec_helper'

describe "ConvoUsersController routing" do
  specify { {:get => "/convos/1/users/manage"}.should route_to(:controller=>"convo_users", :action=>"manage", :convo_id=>"1")}  
  specify { {:get => "/convos/1/users"}.should route_to(:controller=>"convo_users", :action=>"index", :convo_id=>"1")}  
  specify { {:post => "/convos/1/users"}.should route_to(:controller=>"convo_users", :action=>"create", :convo_id=>"1")}  
  specify { {:get => "/convos/1/users/new"}.should route_to(:controller=>"convo_users", :action=>"new", :convo_id=>"1")}  
  specify { {:delete => "/convos/1/users/2"}.should route_to(:controller=>"convo_users", :action=>"destroy", :convo_id=>"1", :id=>'2')}  
end
