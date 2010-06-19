require 'spec_helper'

describe Convo do
  before do
    @user = User.make(:username => "tester", :email => "test@example.com")
    @convo = Convo.create!(:title => "test convo", :user => @user)
  end

  it "should embed one user" do
    @convo.user.should == @user
  end


end
