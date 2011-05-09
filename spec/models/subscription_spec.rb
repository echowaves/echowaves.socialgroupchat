require 'spec_helper'

describe Subscription do
  describe "mongoid-rspec" do
    it { should have_fields(:created_at, :updated_at).of_type(Time) }
    it { should have_field(:last_read_message_id) }
    it { should have_field(:new_messages_count).of_type(Integer) }

    it { should validate_presence_of :convo }
    it { should validate_presence_of :user }


    it { should be_referenced_in :convo }
    it { should be_referenced_in :user }
  end


  describe "business logic" do
    before do
      @user = User.make
      @convo = Convo.make(:owner => @user)
      @subscription = Subscription.create!(:convo => @convo, :user => @user)
    end

    it "should reference convo and user" do
      @subscription.user.should == @user
      @subscription.convo.should == @convo
    end

  end
  
  describe Convo do
    before do
      @user = Factory(:user)
      @convo = Factory(:convo)
    end
    
    it "can have many users subscribed to the convo" do
      user2 = Factory(:user)
      @convo.subscriptions.count.should == 1 # the owner is subscribed
      @convo.subscribe(@user)
      @convo.subscriptions.count.should == 2
      @convo.subscribe(user2)
      @convo.subscriptions.count.should == 3
    end
    
    it "can't have duplicated subscriptions" do
      @convo.subscriptions.count.should == 1 # the owner is subscribed
      @convo.subscribe(@user)
      @convo.subscriptions.count.should == 2
      @convo.subscribe(@user)
      @convo.subscriptions.count.should == 2
    end
  
    it "can have multiple users subscribed" do
      user2 = Factory(:user)
      @convo.subscribe(@user)
      @convo.subscribe(user2)
      @convo.users.should include @user
      @convo.users.should include user2
    end
    
  end
  
  # describe "updated_subscriptions are made to subsriptions" do
  #   before do
  #     @user = Factory(:user)
  #     # this convo will be automatically subscribed because the @user is the owner
  #     @convo = Factory(:convo, :owner => @user)
  #     
  #     # this convo will have to explicitely subscribe because the owner is different
  #     convo = Factory(:convo)
  #     convo.subscribe @user
  #     # let's make another subscription just to make sure it's not affecting anything 
  #     Factory(:subscription)
  #   end
  #   
  #   it "should have 2 subscription" do
  #     @user.subscriptions.count.should == 2
  #   end
  #   
  #   it "should have updated_subscriptions when a new message posted to a subscribed convo which was never visited" do
  #     3.times { Message.make!(:convo => @convo, :owner => @user) }
  #     @user = User.find(@user.id)
  #     @user.updated_subscriptions.count.should == 1
  #     @user.updated_subscriptions[0].new_messages_count.should == 3
  #     # add one more message, new_messages_count increased
  #     Message.make!(:convo => @convo, :owner => @user)
  #     @user.updated_subscriptions[0].new_messages_count.should == 4
  #   end
  # 
  #   it "should have updated_subscriptions when a new message posted to a subscribed convo which was visited before" do
  #     Message.make!(:convo => @convo, :owner => @user)
  #     @user.visit @convo
  #     @user = User.find(@user.id) # have to refetch the user
  #     Message.make!(convo: @convo, owner: @user, created_at: Time.now + 1)
  #     @user.updated_subscriptions[0].new_messages_count.should == 1
  #     # one more message
  #     Message.make!(convo: @convo, owner: @user, created_at: Time.now + 1)
  #     @user.updated_subscriptions[0].new_messages_count.should == 2
  #     # and now visit and it should reset
  #     @user.visit @convo
  #     @user = User.find(@user.id) # have to refetch the user
  #     @user.updated_subscriptions.count.should == 0
  #   end
  # 
  # 
  #   it "should have updates when a new convo created and automatically subscribed"
  #   
  # end


end
