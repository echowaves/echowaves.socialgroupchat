require 'spec_helper'

describe Convo do
  describe "mongoid-rspec" do
    it { should validate_presence_of :owner }
    it { should validate_presence_of :title }
    it { should validate_length_of :title }

    it { should belong_to(:owner).of_type(User) }
    it { should reference_many :messages }
    it { should reference_many :subscriptions }
    it { should reference_many :invitations }
    it { should reference_many :visits }
    
    it { should have_fields(:title, :privacy).of_type(String) }
    
    it { should have_fields(:created_at, :updated_at).of_type(Time) }
    
  end
  
  
  describe "business logic" do
    before do
      @user = User.make(:username => "tester", :email => "test@example.com")
      @convo = Convo.create(:title => "test convo", :owner => @user)
    end


    it "should reference one user" do
      @convo.owner.should == @user
    end
  end


  describe "A convo instance" do
    it "should be public" do
      convo = Convo.make!(:privacy => "public")
      convo.should be_public
    end


    it "should be private" do
      convo = Convo.make!(:privacy => "private")
      convo.should be_private
      convo2 = Convo.make!(:privacy => "anything but public")
      convo2.should be_private
      convo3 = Convo.make!(:privacy => nil)
      convo3.should be_private
    end

    it "should be manageable by user if the user is the creator of the convo" do
      user = User.make
      convo = Convo.make(:owner => user)
      convo.should be_manageable_by_user user
    end

    it "should not be manageable by user if the user is not the creator of the convo" do
      user = User.make
      convo = Convo.make
      convo.should_not be_manageable_by_user user
    end


    it "should be accesible by user if the user is the creator of the convo and the convo is public" do
      user = User.make!
      convo = Convo.make!(:privacy => "public", :owner => user)
      convo.should be_accesible_by_user user
    end


    it "should be accesible by user if the user is the creator of the convo and the convo is private" do
      user = User.make!
      convo = Convo.make!(:privacy => "private", :owner => user)
      convo.should be_accesible_by_user user
    end


    it "should be accesible by user if the user is not the creator of the convo but the convo is public" do
      user = User.make!
      user2 = User.make!
      convo = Convo.make!(:privacy => "public", :owner => user)
      convo.should be_accesible_by_user user2
    end


    it "should not be accesible by user if the user is not the creator of the convo and the convo is private and the user don't follow the convo" do
      user = User.make!
      user2 = User.make!
      convo = Convo.make!(:privacy => "private", :owner => user)
      convo.should_not be_accesible_by_user user2
    end


    it "should be accesible by user if the user is not the creator of the convo and the convo is private but the user follows the convo" do
      user = User.make!
      user2 = User.make!
      convo = Convo.make!(:privacy => "private", :owner => user)
      Subscription.make!(:user => user2, :convo => convo)
      convo.should be_accesible_by_user user2
    end


    it "can have many users subscribed to the convo" do
      user = User.make!
      user2 = User.make!
      convo = Convo.make!
      convo.subscriptions.count.should == 1 # the owner is subscribed
      convo.subscribe(user)
      convo.subscriptions.count.should == 2
      convo.subscribe(user2)
      convo.subscriptions.count.should == 3
    end


    it "can't have duplicated subscriptions" do
      user = User.make!
      convo = Convo.make!
      convo.subscriptions.count.should == 1 # the owner is subscribed
      convo.subscribe(user)
      convo.subscriptions.count.should == 2
      convo.subscribe(user)
      convo.subscriptions.count.should == 2
    end


    it "can have multiple users subscribed" do
      user = User.make!
      user2 = User.make!
      convo = Convo.make!
      convo.subscribe(user)
      convo.subscribe(user2)
      convo.users.should include user
      convo.users.should include user2
    end


    it "can remove a user from the convo" do
      user = User.make!
      user2 = User.make!
      convo = Convo.make!
      convo.subscribe(user)
      convo.subscribe(user2)
      convo.unsubscribe(user)
      convo.unsubscribe(user2)
      # not sure why have to reload, but this fixes the spec
      convo.reload
      convo.users.should_not include user
      convo.users.should_not include user2
    end


    it "should create a subscription when created" do
      user = User.make!
      convo = Convo.make!(:owner => user)
      convo.users.should include user
    end


    it "should not add a user to their subscriptions if the convo is private and the user does not have an invitation" do
      user = User.make
      convo = Convo.make(:privacy => "private")
      convo.subscribe(user)
      convo.users.should_not include user
    end


    it "should create an invitation" do
      user = User.make
      requestor = User.make
      convo = Convo.make(:privacy => "private", :owner => requestor)
      convo.invite_user(user, requestor)
      convo.invitations.count.should == 1
    end


    it "should not create an invitation if a invitation already exists" do
      requestor = User.make!
      user = User.make!
      convo = Convo.make!(:privacy => "private", :owner => requestor)
      convo.invite_user(user, requestor)
      convo.invitations.count.should == 1
      convo.invite_user(user, requestor)
      convo.invitations.count.should == 1
    end

    it "should be able to invite only if has access to the convo" do
      user = User.make
      requestor = User.make
      public_convo = Convo.make(:privacy => "public")
      public_convo.invite_user(user, requestor)
      public_convo.invitations.count.should == 1
      private_convo = Convo.make(:privacy => "private")
      private_convo.invite_user(user, requestor)
      private_convo.invitations.count.should == 0 # no invitation created -- not accessible by the requestor
    end


    it "should add a user to their subscriptions if the user has an invitation" do
      user = User.make
      requestor = User.make
      convo = Convo.make(:owner => requestor, :privacy => 'private')
      convo.invite_user(user, requestor)
      convo.subscribe(user)
      convo.users.should include user
    end


    it "should destroy the invitation when the user is added to the convo" do
      user = User.make!
      requestor = User.make!
      convo = Convo.make!(:owner => requestor, :privacy => 'private')
      convo.invite_user(user, requestor)
      convo.subscribe(user)
      convo.reload
      convo.invitations.count.should == 0
    end
    
  end
end

