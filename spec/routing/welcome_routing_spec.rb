require 'spec_helper'

describe "WelcomeController routing" do
  specify { {:get => "/welcome"}.should route_to(:controller=>"welcome", :action=>"index")}  
  specify { {:get => "/"}.should route_to(:controller=>"welcome", :action=>"index")}  
end
