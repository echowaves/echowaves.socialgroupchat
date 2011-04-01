require 'spec_helper'

describe SubscriptionsController do
  let(:convo) { mock_model(Convo).as_null_object }  
  def mock_subscription(stubs={})
    @mock_subscription ||= mock_model(Subscription, stubs).as_null_object
  end  

  before do
    @user = User.make
    request.env['warden'] = mock(Warden, :authenticate => @user, :authenticate! => @user, :authenticate? => @user)
    mock_subscription.stub(:convo).and_return(convo)
  end

  describe "GET index" do
    it "assigns @convos with only subscribed convos" do
      Subscription.stub_chain(:desc, :where, :paginate) { [mock_subscription] }
      get :index, :user_id => 1

      assigns(:user_id).should eq(1)
      assigns(:subscriptions).should eq([mock_subscription])
      assigns(:convos).should eq([convo])
      response.should render_template(:index)
    end
  end
  
end