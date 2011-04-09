require 'spec_helper'

describe SocketsController do
  specify { {:post => "/socket/subscribe"}.should route_to(:controller=>"sockets", :action=>"subscribe")}  
  specify { {:post => "/socket/unsubscribe"}.should route_to(:controller=>"sockets", :action=>"unsubscribe")}  
end
