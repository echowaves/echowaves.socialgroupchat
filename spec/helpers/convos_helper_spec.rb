require 'spec_helper'

describe ConvosHelper do
  include Devise::TestHelpers
  before do    
    @user = Factory(:user)
    controller.request.env['warden'] = mock(Warden, :authenticate => @user, :authenticate! => @user)    
    @social_convo = Factory(:convo, :privacy_level => 1) #social convo
    @confidential_convo = Factory(:convo, :privacy_level => 0) #confidential convo
  end

  describe "privacy_level rendering" do
    it "is social" do
      content = helper.privacy_level(:convo => @social_convo)
      content.should include "social"
    end
    it "is confidential" do
      content = helper.privacy_level(:convo => @confidential_convo)
      content.should include "confidential"
    end
  end

  describe "accessible rendering" do
    it "is accessible" do
      content = helper.accessible(:convo => @social_convo)
      content.should_not include "not"
      content.should include "accessible"
    end
    it "is not accessible" do
      content = helper.accessible(:convo => @confidential_convo)
      content.should include "accessible"
    end
  end

end
