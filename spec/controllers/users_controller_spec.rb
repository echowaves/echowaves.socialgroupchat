require 'spec_helper'

describe UsersController do
  # let(:convo) { mock_model(Convo).as_null_object }
  def mock_user(stubs={})
    @mock_user ||= mock_model(User, stubs).as_null_object
  end  

  describe "GET index" do
    it "assigns all users as @users" do
      User.stub_chain(:desc, :page) { [mock_user] }
      get :index
      assigns(:users).should eq([mock_user])
    end
  end
  
  describe 'GET show' do
    it 'assigns @user, and renderes it' do
      User.stub(:find).with('37') { mock_user }
      get :show, :id => '37'
      assigns(:user).should be(mock_user)
      response.should render_template(:show) 
    end
  end


  describe 'GET updated_subscriptions' do
    it 'assigns @subscriptions, and renderes it' do
      @user = User.make
      request.env['warden'] = mock(Warden, :authenticate => @user, :authenticate! => @user, :authenticate? => @user)      
      @mock_subcriptions = [mock_model(Subscription).as_null_object]      
      @user.should_receive(:updated_subscriptions).and_return(@mock_subcriptions)
      get "updated_subscriptions"
      assigns(:subscriptions).should == @mock_subcriptions
      response.should render_template(:updated_subscriptions) 
    end
  end


  describe "follow unfollow" do
    before do
      @request.env['HTTP_REFERER'] = '/users'
      User.stub(:find).with("37") { mock_user }
      @user = User.make
      request.env['warden'] = mock(Warden, :authenticate => @user, :authenticate! => @user, :authenticate? => @user)      
    end
    it "follows a leader" do
      @user.should_receive(:follow)
      get :follow, :id => "37"
      flash[:notice].should eq('You followed the user.')
      response.should redirect_to(users_url)
    end

    it 'unfollows a leader' do
      @user.should_receive(:unfollow)
      get :unfollow, :id => '37'
      flash[:notice].should eq('You unfollowed the user.')
      response.should redirect_to(users_url)
    end
    # 
  end


end