require 'spec_helper'

describe SubscriptionsHelper do
  include Devise::TestHelpers
  before do    
    @user = Factory(:user)
    controller.request.env['warden'] = mock(Warden, :authenticate => @user, :authenticate! => @user)    
    @convo = Factory(:convo, :privacy_level => 1) #public convo
  end

  describe "#subscribe_or_unsubscribe_link(:convo, :user)" do
    it "creates subscribe link if the user is not subscribed" do
      content = helper.subscribe_or_unsubscribe_link(:convo => @convo)
      content.should include ">subscribe<"
    end
  end 
  it "creates unsubscribe link if the user is subscribed" do
    @convo.subscribe @user
    content = helper.subscribe_or_unsubscribe_link(:convo => @convo)
    content.should include ">unsubscribe<"
  end
end

