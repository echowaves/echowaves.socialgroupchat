require 'spec_helper'

describe Convo do
  before do
    @user = User.make(:username => "tester", :email => "test@example.com")
    @convo = Convo.create!(:title => "test convo", :user => @user)
  end

  it "should embed one user" do
    @convo.user.should == @user
  end

  # this fail because @user is not embeded in the convo
  # (and it should not)
  it "should keep the records in sync" do
    @user.update_attributes(:username => "changed")
    @convo.reload
    @convo.user.username.should == "changed"
  end

  # this works, is done automatically by mongoid
  # because the embed_one :user
  it "should keep the records in sync 2" do
    @convo.user.update_attributes(:username => "re-changed")
    @user.reload
    @user.username.should == "re-changed"
  end

end
