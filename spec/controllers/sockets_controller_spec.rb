require 'spec_helper'

describe SocketsController do
    it "POSTs subscribe" do
      post :subscribe
      response.body.should == "ok"
    end
  
    it "POSTs unsubscribe" do
      post :unsubscribe
      response.body.should == "ok"
    end
end