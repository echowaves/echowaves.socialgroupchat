require 'spec_helper'

describe UsersController do
  # let(:convo) { mock_model(Convo).as_null_object }
  def mock_user(stubs={})
    @mock_user ||= mock_model(User, stubs).as_null_object
  end  



  describe "GET index" do
    it "assigns all users as @users" do
      User.stub_chain(:order, :page) { [mock_user] }
      get :index
      assigns(:users).should eq([mock_user])
    end
  end
  
  describe 'GET show' do
    before do
      request.env['warden'] = mock(Warden, :authenticate => mock_user, :authenticate! => mock_user, :authenticate? => mock_user)
    end

    it 'assigns @user, and renderes it' do
      User.stub(:find).with('37') { mock_user }
      get :show, :id => '37'
      assigns(:user).should be(mock_user)
      response.should render_template(:show) 
    end

    it 'redirects :back when try to access non logged in user' do
      @request.env['HTTP_REFERER'] = user_path(mock_user)
      @another_mock_user = mock_model(User).as_null_object
      User.stub(:find).with('wrong_convo') { @another_mock_user }
      
      get :show, :id => 'wrong_convo'
      assigns(:user).should be(@another_mock_user)
      flash[:notice].should eq('This is not your profile, you can\'t see it.')      
      response.should redirect_to(user_path(mock_user))      
    end
  end

end