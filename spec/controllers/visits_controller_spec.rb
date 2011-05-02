require 'spec_helper'

describe VisitsController do
  let(:convo) { mock_model(Convo).as_null_object }  

  before do
    @user = User.make
    request.env['warden'] = mock(Warden, :authenticate => @user, :authenticate! => @user, :authenticate? => @user)
    @user.stub(:visited_convos).and_return([convo])
  end

  describe "GET index" do
    it "assigns @convos with only visited convos" do
      get :index

      assigns(:convos).should eq([convo])
      response.should render_template(:index)
      response.should render_template("layouts/visits")
    end
  end
  
end