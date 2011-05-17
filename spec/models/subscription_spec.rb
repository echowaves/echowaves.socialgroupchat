require 'spec_helper'

describe Subscription do

  describe "remarkable" do
    before(:each) do
      @subscription = Factory(:subscription)
    end

    # columns
    #----------------------------------------------------------------------
    it { should have_column :user_id, :type  => :integer, :null => false }
    it { should have_column :convo_id, :type => :integer, :null => false }
    it { should have_column :last_read_message_id, :type => :integer, :default => 0, :null => false }
    it { should have_column :new_messages_count, :type => :integer, :default => 0, :null => false }
    it { should have_column :created_at, :type => :datetime }
    it { should have_column :updated_at, :type => :datetime }

    # indexes
    #----------------------------------------------------------------------
    it { should have_index :user_id }
    it { should have_index :convo_id }
    it { should have_index :created_at }

    # validations
    #----------------------------------------------------------------------
    it { should validate_presence_of :user }
    it { should validate_presence_of :convo }
    it { should validate_uniqueness_of :user_id, :scope => :convo_id }

    # associations
    #----------------------------------------------------------------------
    it { should belong_to :convo }
    it { should belong_to :user }
    #----------------------------------------------------------------------

  end



  describe Convo, User do
    before do
      @user = Factory(:user)
      @convo = Factory(:convo, :owner => @user)
      @subscription = Subscription.first # there should be only one subscription, created automagically
    end

    it "should reference convo and user" do
      @subscription.user.should == @user
      @subscription.convo.should == @convo
    end

  end

  describe Convo do
    before do
      @user = Factory(:user)
      @convo = Factory(:convo, :privacy_level => 1)
    end

    it "can have many users subscribed to the convo" do
      user2 = Factory(:user)
      @convo.subscriptions.count.should == 1 # the owner is auto subscribed
      @convo.subscribe(@user)
      @convo.subscriptions.count.should == 2
      @convo.subscribe(user2)
      @convo.subscriptions.count.should == 3
    end

    it "can't have duplicated subscriptions" do
      @convo.subscriptions.count.should == 1 # the owner is auto subscribed
      @convo.subscribe(@user)
      @convo.subscriptions.count.should == 2
      @convo.subscribe(@user)
      @convo.subscriptions.count.should == 2
    end

    it "can have multiple users subscribed" do
      user2 = Factory(:user)
      @convo.subscribe(@user)
      @convo.subscribe(user2)
      @convo.subscribers.should include @user
      @convo.subscribers.should include user2
    end

  end

  describe "updated_subscriptions are made to subsriptions" do
    before do
      @user = Factory(:user)
      # this convo will be automatically subscribed because the @user is the owner
      @convo = Factory(:convo, :owner => @user)

      # this convo will have to explicitely subscribe because the owner is different
      convo = Factory(:convo, privacy_level: 1)
      convo.subscribe @user
      # let's make another subscription just to make sure it's not affecting anything 
      Factory(:subscription)
    end

    it "should have 2 subscription" do
      @user.subscriptions.count.should == 2
    end

    it "should have updated_subscriptions when a new message posted to a subscribed convo which was never visited" do
      3.times { Factory(:message, :convo => @convo, :owner => @user) }
      # @user.reload
      @user.updated_subscriptions.count.should == 1
      @user.updated_subscriptions[0].new_messages_count.should == 3
      # add one more message, new_messages_count increased
      Factory(:message, :convo => @convo, :owner => @user)
      @user.updated_subscriptions[0].new_messages_count.should == 4
    end

    it "should have updated_subscriptions when a new message posted to a subscribed convo which was visited before" do
      Factory(:message, :convo => @convo, :owner => @user)
      @user.visit @convo
      @user.reload # have to refetch the user
      Factory(:message, convo: @convo, owner: @user)
      @user.updated_subscriptions[0].new_messages_count.should == 1
      # one more message
      Factory(:message, convo: @convo, owner: @user)
      @user.updated_subscriptions[0].new_messages_count.should == 2
      # and now visit and it should reset
      @user.visit @convo
      @user.reload # have to refetch the user
      @user.updated_subscriptions.count.should == 0
    end

  end

end
