require 'spec_helper'

describe SubscriptionsController do
  let(:user)  { Factory(:user) }  
  let(:convo) { Factory(:convo, :owner => user) }  

  before do
    request.env['warden'] = mock(Warden, :authenticate => user, :authenticate! => user, :authenticate? => user)
    @request.env['HTTP_REFERER'] = convos_path
  end

  
  describe "index, subscribe, unsubscribe" do
    before do
      user
      convo
    end

    it "GET index with convo_id" do
      Convo.stub(:find).and_return(convo)
      get :index, :convo_id => "37"
      assigns(:subscriptions).should == convo.subscriptions.all
      response.should render_template("index")
    end
 
    it "GET index with user_id" do
      User.stub(:find).and_return(user)
      get :index, :user_id => "37"
      assigns(:subscriptions).should == user.subscriptions.all
      response.should render_template("index")
    end

    it "allows user to subscribe to a social convo" do
      Convo.stub(:find).and_return(convo)
      convo.stub(:accesible_by_user?) { true }
      convo.should_receive(:subscribe)
      post :create, :convo_id => "37"
      flash[:notice].should eq("You are subscribed to the conversation.")
      response.should redirect_to(convos_url)
    end
    
    it "rejects user attempt to subscribe to private convo" do
      Convo.stub(:find).and_return(convo)
      convo.stub(:accesible_by_user?) { false } #different from previous spec
      convo.should_not_receive(:subscribe)
      post :create, :convo_id => "37"
      flash[:notice].should eq("Sorry, but you can't access this conversation.")
      response.should redirect_to(convos_url)
    end
    
    it 'unsubscribes user from convo' do
      Convo.stub(:find).and_return(convo)
      User.stub(:find).and_return(user)
      convo.should_receive(:unsubscribe)
      delete :destroy, :convo_id => '37', :user_id => '42', :id => 'does_not_matter_but_has_to_be_passed'
      flash[:notice].should eq('Unsubscribed from the conversation.')
      response.should redirect_to(convos_url)
    end

    it 'fails to unsubscribe user from convo' do
      convo = Factory(:convo) # create a new convo
      Convo.stub(:find).and_return(convo)
      User.stub(:find).and_return(user)
      convo.should_not_receive(:unsubscribe)
      delete :destroy, :convo_id => '37', :user_id => '42', :id => 'does_not_matter_but_has_to_be_passed'
      flash[:notice].should eq('Unable to unsubscribe.')
      response.should redirect_to(convos_url)
    end
    
  end
  
end