require 'spec_helper'

describe FollowershipsController do
  specify { {:post   => "/users/:user_id/followerships"}.should route_to(:controller=>"followerships", :action=>"create", :user_id =>":user_id")}  
  specify { {:delete => "/users/:user_id/followerships/:id"}.should route_to(:controller=>"followerships", :action=>"destroy", :user_id =>":user_id", :id =>":id")}  
end
