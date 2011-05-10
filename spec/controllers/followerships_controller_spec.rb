require 'spec_helper'

describe FollowershipsController do
  let(:convo) { mock_model(Convo).as_null_object }  
  def mock_user(stubs={})
    @mock_user ||= mock_model(User, stubs).as_null_object
  end  

  before do
    @user = Factory(:user)
    request.env['warden'] = mock(Warden, :authenticate => @user, :authenticate! => @user, :authenticate? => @user)
    @user.stub(:visited_convos).and_return([convo])
  end

  describe "follow unfollow" do
    before do
      @request.env['HTTP_REFERER'] = '/users'
      User.stub(:find).with("37") { mock_user }
      @user = Factory(:user)
      request.env['warden'] = mock(Warden, :authenticate => @user, :authenticate! => @user, :authenticate? => @user)      
    end
    
    it "follows a leader" do
      @user.should_receive(:follow)
      post :create, :user_id => "37"
      flash[:notice].should eq('You followed the user.')
      response.should redirect_to(users_url)
    end

    it 'unfollows a leader' do
      @user.should_receive(:unfollow)
      delete :destroy, :user_id => '37', :id => '42'
      flash[:notice].should eq('You unfollowed the user.')
      response.should redirect_to(users_url)
    end
    
  end


end