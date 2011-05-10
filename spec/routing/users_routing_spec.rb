require 'spec_helper'

describe UsersController do
  specify { {:get => "/users"}.should route_to(:controller=>"users", :action=>"index")}  
  specify { {:get => "/users/1"}.should route_to(:controller=>"users", :action=>"show", :id=>"1")}  
end
