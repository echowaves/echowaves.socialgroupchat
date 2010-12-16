require 'spec_helper'

describe Subscription do
  before do
    @user = User.make(:username => "tester", :email => "test@example.com")
    @convo = Convo.make(:title => "test convo", :user => @user)
    @subscription = Subscription.create!(:convo => @convo, :user => @user)
  end

  it "should reference convo and user" do
    @subscription.user.should == @user
    @subscription.convo.should == @convo
  end
end
