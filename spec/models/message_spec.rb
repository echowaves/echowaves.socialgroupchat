require 'spec_helper'

describe Message do
  before do
    @user = User.make(:username => "tester", :email => "test@example.com")
    @convo = Convo.make(:title => "test convo", :user => @user)
    @message = Message.create!(:convo => @convo, :user => @user, :body => Sham.body )
  end

  it "should reference convo and user, and contain body" do
    @message.user.should == @user
    @message.convo.should == @convo
    @message.body.length.should > 0
  end
end
