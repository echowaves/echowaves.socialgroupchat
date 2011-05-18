require 'spec_helper'

describe SubscriptionsController do
  let(:convo) { mock_model(Convo).as_null_object }  
  def mock_subscription(stubs={})
    @mock_subscription ||= mock_model(Subscription, stubs).as_null_object
  end  
  def mock_convo(stubs={})
    @mock_convo ||= mock_model(Convo, stubs).as_null_object
  end  

  before do
    @user = mock_model(User).as_null_object
    request.env['warden'] = mock(Warden, :authenticate => @user, :authenticate! => @user, :authenticate? => @user)
    mock_subscription.stub(:convo).and_return(convo)
  end

  
  describe "index, subscribe, unsubscribe" do
    before do
      @request.env['HTTP_REFERER'] = convos_path
      Convo.stub(:find).with("37") { mock_convo }
    end


    it "GET index" do
      mock_convo.stub_chain(:subscriptions, :page) { [mock_subscription]}      
      get :index, :convo_id => "37"
      assigns(:subscriptions).should eq([mock_subscription])      
      response.should render_template("index")
    end

    it "allows user to subscribe to a social convo" do
      mock_convo.stub(:accesible_by_user?) { true }
      mock_convo.should_receive(:subscribe)
      post :create, :convo_id => "37"
      flash[:notice].should eq("You are subscribed to the conversation.")
      response.should redirect_to(convos_url)
    end

    it "rejects user attempt to subscribe to private convo" do
      mock_convo.stub(:accesible_by_user?) { false }
      mock_convo.should_not_receive(:subscribe)
      post :create, :convo_id => "37"
      flash[:notice].should eq("Sorry, but you can't access this conversation.")
      response.should redirect_to(convos_url)
    end

    it 'unsubscribes user from convo' do
      mock_convo.should_receive(:unsubscribe)
      delete :destroy, :convo_id => '37', :id => 'does_not_matter_but_has_to_be_passed'
      flash[:notice].should eq('You are unsubscribed from the conversation.')
      response.should redirect_to(convos_url)
    end
  end
  
end