require 'spec_helper'

describe Invitation do
  it "should generate a token when created" do
    user = User.make
    requestor = User.make
    convo = Convo.make
    invite = Invitation.create(:user => user, :requestor_id => requestor.id, :convo => convo)
    invite.token.should match(/[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}/)

  end
end
