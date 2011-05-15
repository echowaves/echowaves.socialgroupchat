require 'spec_helper'

describe SubscriptionsController do
  specify { {:post   => "/convos/:convo_id/subscriptions"}.should route_to(:controller=>"subscriptions", :action=>"create", :convo_id =>":convo_id")}  
  specify { {:delete => "/convos/:convo_id/subscriptions/:id"}.should route_to(:controller=>"subscriptions", :action=>"destroy", :convo_id =>":convo_id", :id =>":id")}  
end
