require 'spec_helper'

describe UpdatesController do
  let(:subscription) { mock_model(Subscription).as_null_object }  

  before do
    @user = User.make
    request.env['warden'] = mock(Warden, :authenticate => @user, :authenticate! => @user, :authenticate? => @user)
    @user.stub(:updated_subscriptions).and_return([subscription])
  end

  describe "GET index" do
    it "assigns @subscriptions with only updates" do
      get :index

      assigns(:subscriptions).should eq([subscription])
      response.should render_template(:index)
      response.should render_template("layouts/updates")
      
    end
  end
  
end