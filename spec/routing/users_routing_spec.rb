require 'spec_helper'

describe "UsersController routing" do
  specify { {:get => "/users"}.should route_to(:controller=>"users", :action=>"index")}  
  specify { {:get => "/users/1"}.should route_to(:controller=>"users", :action=>"show", :id=>"1")}  
  specify { {:get => "/users/:id/follow"}.should route_to(:controller=>"users", :action=>"follow", :id=>":id")}  
  specify { {:get => "/users/:id/unfollow"}.should route_to(:controller=>"users", :action=>"unfollow", :id=>":id")}  
  
end
