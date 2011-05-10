require 'spec_helper'

describe MessagesController do
  let(:message) { mock_model(Message).as_null_object }  
  def mock_convo(stubs={})
    @mock_convo ||= mock_model(Convo, stubs).as_null_object
  end  

  before do
    @user = Factory(:user)
    request.env['warden'] = mock(Warden, :authenticate => @user, :authenticate! => @user, :authenticate? => @user)
    Convo.stub(:find) {mock_convo}
    mock_convo.stub(:messages) {[message]}
  end


  describe "GET index" do
    it "assigns @messages" do
      get :index, :convo_id => 37
      assigns(:raw_messages).should eq(mock_convo.messages)
      response.should redirect_to(convo_url(mock_convo))
    end
  end


  describe "POST create" do
    it "creates message and sends it" do
      Message.stub(:create) { message }
      @user.should_receive(:visit).with(mock_convo)
      post :create, :convo_id => 37, :format => :js
      # Socky.should_receive(:send)
      # response.should redirect_to(convo_url(mock_convo))
      response.should be_success 
      response.body.strip.should be_empty
    end
  end

end
