require 'spec_helper'

describe UpdatesController do
  specify { {:get => "/updates"}.should route_to(:controller=>"updates", :action=>"index")}
end
