require 'spec_helper'

describe InvitationsController do
  specify { {:get => "/invitations"}.should route_to(:controller=>"invitations", :action=>"index")}
  specify { {:get => "/invitations/new"}.should route_to(:controller=>"invitations", :action=>"new")}
  specify { {:post => "/invitations"}.should route_to(:controller=>"invitations", :action=>"create")}
end
