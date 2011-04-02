require 'spec_helper'

describe "SubscriptionsController routing" do  
  specify { {:get => "/users/1/subscriptions"}.should route_to(:controller=>"subscriptions", :action=>"index", :user_id=>"1")}
end
