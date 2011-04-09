require 'spec_helper'

describe VisitsController do
  specify { {:get => "/visits"}.should route_to(:controller=>"visits", :action=>"index")}
end
