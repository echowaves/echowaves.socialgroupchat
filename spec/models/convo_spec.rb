require 'spec_helper'

describe Convo do
  before do
    @user = User.make(:username => "tester", :email => "test@example.com")
    @convo = Convo.create!(:title => "test convo", :user => @user)
  end

  it "should embed one user" do
    @convo.user.should == @user
  end

  it "should keep the user record in sync" do
    @user.update_attributes(:username => "changed")
    @convo.user.username.should == "changed"
    @convo.user.update_attributes(:username => "re-changed")
    @user.username.should == "re-changed"
    User.last.username.should == "re-changed"
    Convo.last.user.username.should == "re-changed"
  end

end
