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
    it 'assigns @user, and renderes it' do
      User.stub(:find).with('37') { mock_user }
      get :show, :id => '37'
      assigns(:user).should be(mock_user)
      response.should render_template(:show) 
    end
  end

end