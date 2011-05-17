require 'spec_helper'

describe ConvoUsersController do
  let(:user) { mock_model(User).as_null_object }  
  def mock_convo(stubs={})
    @mock_convo ||= mock_model(Convo, stubs).as_null_object
  end  

  before do
    @user = Factory(:user)
    request.env['warden'] = mock(Warden, :authenticate => @user, :authenticate! => @user, :authenticate? => @user)
    Convo.stub(:find).and_return(mock_convo)
    mock_convo.stub(:users).and_return([user])
  end


  describe "GET index" do
    it "assigns @convos with only subscribed convos" do
      get :index, :convo_id => 37
      
      assigns(:subscribers).should eq(mock_convo.subscribers)
      response.should render_template(:index)
      response.should render_template("layouts/convo_one_panel") 
    end
  end


  describe "GET manage" do
    it "assigns @users from convo if allowed to manage" do
      mock_convo.should_receive(:manageable_by_user?).and_return(true)
      get :manage, :convo_id => 37
      assigns(:subscribers).should eq(mock_convo.subscribers)
      response.should render_template(:manage)      
    end

    it "can't manage" do
      mock_convo.should_receive(:manageable_by_user?).and_return(false)
      get :manage, :convo_id => 37
      response.should redirect_to(convo_path(mock_convo)) 
      flash[:alert].should eq("You can't manage this convo.")
    end
  end
  
end
