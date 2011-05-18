require 'spec_helper'

describe Convo do
  describe "remarkable" do
    before(:each) do
      @convo = Factory(:convo)
    end

    # columns
    #----------------------------------------------------------------------
    it { should have_column :title, type: :string, limit: 140, null: false }
    it { should have_column :privacy_level, type: :integer, default: 0 }
    it { should have_column :read_only, type: :boolean, default: false, null: false }
    it { should have_column :owner_id, type: :integer, null: false }
    it { should have_column :messages_count, type: :integer, :default => 0 }
    it { should have_column :subscriptions_count, type: :integer, :default => 0 }
    it { should have_column :created_at, type: :datetime }
    it { should have_column :updated_at, type: :datetime }

    # indexes
    #----------------------------------------------------------------------
    it { should have_index :privacy_level }
    it { should have_index :created_at }
    it { should have_index :owner_id }

     
    # validations
    #----------------------------------------------------------------------
    it { should validate_presence_of :title }
    it { should validate_presence_of :owner }
    it { should validate_presence_of :privacy_level }
    it { should validate_length_of :title, :maximum => 140 }


    # associations
    #----------------------------------------------------------------------
    it { should belong_to :owner, class_name: "User"}
    it { should have_many :messages }
    it { should have_many :subscriptions }
    it { should have_many :subscribers, through: :subscriptions, :source => :user }
    it { should have_many :invitations }
    it { should have_many :visits }
    it { should have_many :visiting_users, through: :visits, source: :user }
  end

  
  describe User, Convo do
    before do
      @user = Factory(:user)
      @convo = Factory(:convo, :owner => @user)
    end
    
    it "should reference one user" do
      @convo.owner.should == @user
    end
  end
  
  
  describe User do
    before do
      @user = Factory(:user)
    end


    it "should be social" do
      convo = Factory(:convo, :privacy_level => 1 ) # a social convo
      convo.should be_social
    end
  
  
    it "should be confidential" do
      convo = Factory(:convo, :privacy_level => 0 ) # a confidential convo
      convo.should be_confidential
    end
  
    it "should be manageable by user if the user is the creator of the 179" do
      convo = Factory(:convo, :owner => @user)
      convo.should be_manageable_by_user @user
    end
  
    it "should not be manageable by user if the user is not the creator of the convo" do
      convo = Factory(:convo)
      convo.should_not be_manageable_by_user @user
    end
  
  
    it "should be accesible by user if the user is the creator of the convo and the convo is social" do
      convo = Factory(:convo, :privacy_level => 1, :owner => @user)
      convo.should be_accesible_by_user @user
    end
  
  
    it "should be accesible by user if the user is the creator of the convo and the convo is confidential" do
      convo = Factory(:convo, :privacy_level => 0, :owner => @user)
      convo.should be_accesible_by_user @user
    end
  
  
    it "should be accesible by user if the user is not the creator of the convo but the convo is social" do
      user2 = Factory(:user)
      convo = Factory(:convo, :privacy_level => 1, :owner => @user)
      convo.should be_accesible_by_user user2
    end
  
    it "should not be accesible by user if the user is not the creator of the convo and the convo is confidential and the user don't follow the convo" do
      user2 = Factory(:user)
      convo = Factory(:convo, :privacy_level => 0, :owner => @user)
      convo.should_not be_accesible_by_user user2
    end
  
    it "should be accesible by user if the user is not the creator of the convo and the convo is confidential but the user follows the convo" do
      user2 = Factory(:user)
      convo = Factory(:convo, :privacy_level => 0, :owner => @user)
      Factory(:subscription, :user => user2, :convo => convo)
      convo.should be_accesible_by_user user2
    end  
  
    it "can remove a user from the convo" do
      user2 = Factory(:user)
      convo = Factory(:convo)
      convo.subscribe(@user)
      convo.subscribe(user2)
      convo.unsubscribe(@user)
      convo.unsubscribe(user2)
      # not sure why have to reload, but this fixes the spec
      convo.reload
      convo.subscribers.should_not include @user
      convo.subscribers.should_not include user2
    end
  
    it "should create a subscription when created" do
      convo = Factory(:convo, :owner => @user)
      convo.subscribers.should include @user
    end
    
    it "should not add a user to their subscriptions if the convo is confidential and the user does not have an invitation" do
      convo = Factory(:convo, :privacy_level => 0)
      convo.subscribe(@user)
      convo.subscribers.should_not include @user
    end
  
    it "should create an invitation" do
      requestor = Factory(:user)
      convo = Factory(:convo, privacy_level: 0, :owner => requestor)
      convo.invite_user(@user, requestor)
      convo.invitations.count.should == 1
    end
  
    it "should not create an invitation if a invitation already exists" do
      requestor = Factory(:user)
      convo = Factory(:convo, :privacy_level => 0, :owner => requestor)
      convo.invite_user(@user, requestor)
      convo.invitations.count.should == 1
      convo.invite_user(@user, requestor)
      convo.invitations.count.should == 1
    end
  
    it "should be able to invite only if has access to the convo" do
      requestor = Factory(:user)
      social_convo = Factory(:convo, privacy_level: 1)
      social_convo.invite_user(@user, requestor)
      social_convo.invitations.count.should == 1
      confidential_convo = Factory(:convo, privacy_level: 0)
      confidential_convo.invite_user(@user, requestor)
      confidential_convo.invitations.count.should == 0 # no invitation created -- not accessible by the requestor
    end
  
    it "should add a user to their subscriptions if the user has an invitation" do
      requestor = Factory(:user)
      convo = Factory(:convo, :owner => requestor, privacy_level: 0)
      convo.invite_user(@user, requestor)
      convo.subscribe(@user)
      convo.subscribers.should include @user
    end
 
    it "should destroy the invitation when the user is added to the convo" do
      requestor = Factory(:user)
      convo = Factory(:convo, :owner => requestor, privacy_level: 0)
      convo.invite_user(@user, requestor)
      convo.subscribe(@user)
      convo.reload
      # once sunscribed to an invited convo, should not destroy the original invitation
      convo.invitations.count.should == 1
    end
    
  end
end

