require 'spec_helper'

describe InvitationsController do
  # let(:invitation) { mock_model(Invitation).as_null_object }
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
      @convo     = Factory(:convo)
      @follower1 = Factory(:user)
      @follower2 = Factory(:user)      
      @follower1.follow @user
      @follower2.follow @user
      @convo.subscribe @follower1
    end
    
    it "assigns @convo and @followers" do
      get :new, :convo_id => @convo.id
      assigns(:convo).should eq(@convo)
      assigns(:followers).should eq(@user.followers - @convo.subscribers)
      response.should render_template(:new)
    end
  end


  describe "POST create" do
    before do
      @convo = Factory(:convo)
      @request.env['HTTP_REFERER'] = new_invitation_path(:convo_id => @convo.id)
      @user_to_invite = Factory(:user)
    end
    
    it "assignes @invitation and saves it" do
      post :create, :convo_id => @convo.id, :user_id => @user_to_invite.id
      flash[:notice].should eq('Invitation sent.')      
      response.should redirect_to(new_invitation_path(:convo_id => @convo.id))
    end

    it "assignes @invitation and fails to save it" do
      post :create, :convo_id => @convo.id
      flash[:notice].should eq('Unable to send invitation.')      
      response.should redirect_to(new_invitation_path(:convo_id => @convo.id))
    end

    it "assignes @invitation and fails to save it when non parameters are passed in" do
      post :create
      flash[:notice].should eq('Unable to send invitation.')      
      response.should redirect_to(new_invitation_path(:convo_id => @convo.id))
    end

  end

  describe "PUT accept" 
  
  describe "DELETE destroy" 
  
end
