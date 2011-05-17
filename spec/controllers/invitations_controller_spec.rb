require 'spec_helper'

describe InvitationsController do
  let(:convo) { mock_model(Convo).as_null_object }  

  before do
    @user = Factory(:user)
    request.env['warden'] = mock(Warden, :authenticate => @user, :authenticate! => @user, :authenticate? => @user)
    @user.stub(:convo_invites).and_return([convo])
  end

  describe "GET index" do
    it "assigns @convos with only convo invites" do
      get :index

      assigns(:convos).should eq([convo])
      response.should render_template(:index)
    end
  end

  describe "GET new" do
    before do
      @follower = Factory(:user)
      @follower.follow @user
    end
    it "assigns @followers with only convo invites" do
      get :new

      assigns(:followers).should eq([@follower])
      response.should render_template(:new)
    end
  end

  
end
