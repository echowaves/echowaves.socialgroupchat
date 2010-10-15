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

describe "A convo instance" do
  it "should be public" do
    convo = Convo.make(:privacy => "public")
    convo.should be_public
  end

  it "should be private" do
    convo = Convo.make(:privacy => "private")
    convo.should be_private
    convo2 = Convo.make(:privacy => "anything but public")
    convo2.should be_private
    convo3 = Convo.make(:privacy => nil)
    convo3.should be_private
  end

  it "should be accesible by user if the user is the creator of the convo and the convo is public" do
    user = User.make
    convo = Convo.make(:privacy => "public", :user => user)
    convo.should be_accesible_by_user user
  end

  it "should be accesible by user if the user is the creator of the convo and the convo is private" do
    user = User.make
    convo = Convo.make(:privacy => "private", :user => user)
    convo.should be_accesible_by_user user
  end

  it "should be accesible by user if the user is not the creator of the convo but the convo is public" do
    user = User.make
    user2 = User.make
    convo = Convo.make(:privacy => "public", :user => user)
    convo.should be_accesible_by_user user2
  end

  it "should not be accesible by user if the user is not the creator of the convo and the convo is private and the user don't follow the convo" do
    user = User.make
    user2 = User.make
    convo = Convo.make(:privacy => "private", :user => user)
    convo.should_not be_accesible_by_user user2
  end

  it "should be accesible by user if the user is not the creator of the convo and the convo is private but the user follows the convo" do
    user = User.make
    user2 = User.make
    convo = Convo.make(:privacy => "private", :user => user)
    ConvoUser.make(:user => user2, :convo => convo)
    convo.should be_accesible_by_user user2
  end

end

