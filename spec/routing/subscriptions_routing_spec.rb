require 'spec_helper'

describe SubscriptionsController do
  specify { {:get   => "/subscriptions"}.should route_to(:controller=>"subscriptions", :action=>"index")}  
  specify { {:post   => "/subscriptions"}.should route_to(:controller=>"subscriptions", :action=>"create")}  
  specify { {:delete => "/subscriptions/:id"}.should route_to(:controller=>"subscriptions", :action=>"destroy", :id =>":id")} # sadly the id will be ignore, need to pass convo_id and user_id as a quiery string 
end
