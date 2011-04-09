require 'spec_helper'

describe ConvosController do
  specify { {:get => "/convos/:id/subscribe"}.should route_to(:controller=>"convos", :action=>"subscribe", :id=>":id")}  
  specify { {:get => "/convos/:id/unsubscribe"}.should route_to(:controller=>"convos", :action=>"unsubscribe", :id=>":id")}  

  specify { {:get => "/convos"}.should route_to(:controller=>"convos", :action=>"index")}  
  specify { {:post => "/convos"}.should route_to(:controller=>"convos", :action=>"create")}  
  specify { {:get => "/convos/new"}.should route_to(:controller=>"convos", :action=>"new")}  
  specify { {:get => "/convos/1"}.should route_to(:controller=>"convos", :action=>"show", :id=>'1')}  
end
