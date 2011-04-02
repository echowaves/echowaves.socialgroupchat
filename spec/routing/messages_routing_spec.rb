require 'spec_helper'

describe "MessagesController routing" do
  specify { {:get => "/convos/1/messages"}.should route_to(:controller=>"messages", :action=>"index", :convo_id=>"1")}  
  specify { {:post => "/convos/1/messages"}.should route_to(:controller=>"messages", :action=>"create", :convo_id=>"1")}  
  specify { {:get => "/convos/1/messages/2"}.should route_to(:controller=>"messages", :action=>"show", :convo_id=>"1", :id=>"2")}  
end
