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
    Subscription.make(:user => user2, :convo => convo)
    convo.should be_accesible_by_user user2
  end

  it "can have many users subscribed to the convo" do
    user = User.make
    user2 = User.make
    convo = Convo.make
    convo.subscriptions.count.should == 1 # the owner is subscribed
    convo.add_user(user)
    convo.subscriptions.count.should == 2
    convo.add_user(user2)
    convo.subscriptions.count.should == 3
  end

  it "can't have duplicated subscriptions" do
    user = User.make
    convo = Convo.make
    convo.subscriptions.count.should == 1 # the owner is subscribed
    convo.add_user(user)
    convo.subscriptions.count.should == 2
    convo.add_user(user)
    convo.subscriptions.count.should == 2
  end

  it "can have multiple users subscribed" do
    user = User.make
    user2 = User.make
    convo = Convo.make
    convo.add_user(user)
    convo.add_user(user2)
    convo.users.should include user
    convo.users.should include user2
  end

  it "can remove a user from the convo" do
    user = User.make
    user2 = User.make
    convo = Convo.make
    convo.add_user(user)
    convo.add_user(user2)
    convo.remove_user(user)
    convo.remove_user(user2)
    convo.users.should_not include user
    convo.users.should_not include user2
  end

  it "should create a subscription when created" do
    user = User.make
    convo = Convo.make(:user => user)
    convo.users.should include user
  end

end

