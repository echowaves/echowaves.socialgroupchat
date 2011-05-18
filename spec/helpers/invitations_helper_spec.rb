require 'spec_helper'

describe InvitationsHelper do
  before do
    @convo = Factory(:convo)
    @user =  Factory(:user)
  end
  it "creates invite link if the there is no invitation yet" do
    content = helper.invitation_link(:convo => @convo, :user => @user)
    content.should include ">invite<"
  end
  it "render nothing if there is invitation already" do
    Factory(:invitation, :user => @user, :convo => @convo)
    content = helper.invitation_link(:convo => @convo, :user => @user)
    content.should be_blank
  end

  describe "appect and cancel links" do
    before do
      @invitation = Factory(:invitation, :convo => @convo, :user => @user)
    end
    
    it "renderes accept_link" do
      content = helper.accept_link(:invitation => @invitation)
      content.should include ">accept<"
    end

    it "renderes cancel_link" do
      content = helper.cancel_link(:invitation => @invitation)
      content.should include ">cancel<"
    end
  end

end
