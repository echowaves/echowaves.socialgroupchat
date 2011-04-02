require 'spec_helper'

describe "devise routing" do
  specify { {:get => "/users/sign_in"}.should route_to(:controller=>"devise/sessions", :action=>"new")}
  specify { {:post => "/users/sign_in"}.should route_to(:controller=>"devise/sessions", :action=>"create")}
  specify { {:get => "/users/sign_out"}.should route_to(:controller=>"devise/sessions", :action=>"destroy")}

  specify { {:post => "/users/password"}.should route_to(:controller=>"devise/passwords", :action=>"create")}
  specify { {:get => "/users/password/new"}.should route_to(:controller=>"devise/passwords", :action=>"new")}
  specify { {:get => "/users/password/edit"}.should route_to(:controller=>"devise/passwords", :action=>"edit")}
  specify { {:put => "/users/password"}.should route_to(:controller=>"devise/passwords", :action=>"update")}

  specify { {:get => "/users/cancel"}.should route_to(:controller=>"devise/registrations", :action=>"cancel")}
  specify { {:post => "/users"}.should route_to(:controller=>"devise/registrations", :action=>"create")}
  specify { {:get => "/users/sign_up"}.should route_to(:controller=>"devise/registrations", :action=>"new")}
  specify { {:get => "/users/edit"}.should route_to(:controller=>"devise/registrations", :action=>"edit")}
  specify { {:put => "/users"}.should route_to(:controller=>"devise/registrations", :action=>"update")}
  specify { {:delete => "/users"}.should route_to(:controller=>"devise/registrations", :action=>"destroy")}

  specify { {:post => "/users/confirmation"}.should route_to(:controller=>"devise/confirmations", :action=>"create")}
  specify { {:get => "/users/confirmation/new"}.should route_to(:controller=>"devise/confirmations", :action=>"new")}
  specify { {:get => "/users/confirmation"}.should route_to(:controller=>"devise/confirmations", :action=>"show")}
end
