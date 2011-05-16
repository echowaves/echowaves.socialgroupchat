require 'spec_helper'

describe SubscriptionsHelper do
  include Devise::TestHelpers
  before do    
    @user = Factory(:user)
    controller.request.env['warden'] = mock(Warden, :authenticate => @user, :authenticate! => @user)    
    @social_convo = Factory(:convo, :privacy_level => 1) #social convo
  end

  it "should not produce any output if the user does not have access to a convo" do
    @confidential_convo = Factory(:convo, :privacy_level => 0) #confidential convo
    content = helper.subscribe_or_unsubscribe_link(:convo => @confidential_convo)
    content.should be_blank
  end

  describe "#subscribe_or_unsubscribe_link(:convo, :user)" do
    it "creates subscribe link if the user is not subscribed" do
      content = helper.subscribe_or_unsubscribe_link(:convo => @social_convo)
      content.should include ">subscribe<"
    end
  end
   
  it "creates unsubscribe link if the user is subscribed" do
    @social_convo.subscribe @user
    content = helper.subscribe_or_unsubscribe_link(:convo => @social_convo)
    content.should include ">unsubscribe<"
  end
end

