require 'spec_helper'

describe InvitationsController do
  specify { {:get => "/invitations"}.should route_to(:controller=>"invitations", :action=>"index")}
  specify { {:get => "/invitations/new"}.should route_to(:controller=>"invitations", :action=>"new")}
  specify { {:post => "/invitations"}.should route_to(:controller=>"invitations", :action=>"create")}
  specify { {:delete => "/invitations/:id"}.should route_to(:controller=>"invitations", :action=>"destroy", :id=>':id')}
  specify { {:put => "/invitations/:id/accept"}.should route_to(:controller=>"invitations", :action=>"accept", :invitation_id=>':id')}
end
