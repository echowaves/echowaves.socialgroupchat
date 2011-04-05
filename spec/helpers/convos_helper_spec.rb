require 'spec_helper'

describe ConvosHelper do
  describe "#subscribe_or_unsubscribe_link(:convo, :user)" do
    it "creates subscribe link if the user is not subscribed" do
      user = User.make
      convo = Convo.make!
      content = helper.subscribe_or_unsubscribe_link(:convo => convo, :user => user)
      content.should include ">subscribe<"
    end
  end 
  it "creates unsubscribe link if the user is subscribed" do
    user = User.make!
    convo = Convo.make!
    convo.subscribe user
    content = helper.subscribe_or_unsubscribe_link(:convo => convo, :user => user)
    content.should include ">unsubscribe<"
  end
end
