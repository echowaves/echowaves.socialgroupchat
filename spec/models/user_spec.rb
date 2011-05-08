require 'spec_helper'

describe User do

  describe "remarkable" do
    before(:each) do
      @user = Factory(:user)
    end

    # columns
    #----------------------------------------------------------------------
    it { should have_column :username, :type => :string, :limit => 128 }
    it { should have_column :email,    :type => :string, :limit => 255, :default => '', :null => false }
    it { should have_column :encrypted_password,    :type => :string, :limit => 128, :default => '', :null => false }
    it { should have_column :confirmation_token, :type => :string, :limit => 255 }
    it { should have_column :confirmed_at, :type => :datetime }
    it { should have_column :confirmation_sent_at, :type => :datetime }
    it { should have_column :reset_password_token,    :type => :string, :limit => 255 }
    it { should have_column :remember_token,    :type => :string, :limit => 255 }
    it { should have_column :remember_created_at, :type => :datetime }
    it { should have_column :sign_in_count, :type => :integer, :default => 0 }
    it { should have_column :current_sign_in_at, :type => :datetime }
    it { should have_column :last_sign_in_at, :type => :datetime }
    it { should have_column :current_sign_in_ip, :type => :string, :limit => 255 }
    it { should have_column :last_sign_in_ip, :type => :string, :limit => 255 }
    it { should have_column :password_salt, :type => :string, :limit => 255 }
    it { should have_column :created_at, :type => :datetime }
    it { should have_column :updated_at, :type => :datetime }

    # indexes
    #----------------------------------------------------------------------
    it { should have_index :username }
    it { should have_index :email }
    it { should have_index :confirmation_token }
    it { should have_index :reset_password_token }
    it { should have_index :created_at }
     
    # validations
    #----------------------------------------------------------------------
    it { should validate_presence_of :username }
    it { should validate_uniqueness_of :username }


    it { should validate_uniqueness_of( :username) }
    it { should validate_uniqueness_of( :email) }

    # associations
    #----------------------------------------------------------------------
    it { should have_many :subscriptions }
    it { should have_many :invitations }

    it { should have_many :followerships, :foreign_key => "leader_id" }
    it { should have_many :followers, :through => :followerships }
     
    it { should have_many :leaderships, :class_name => "Followership", :foreign_key => "follower_id" }
    it { should have_many :leaders, :through => :leaderships }
    
    it { should have_many :visits }
    it { should have_many :convos,   :foreign_key => "owner_id" }
    it { should have_many :messages, :foreign_key => "owner_id" }

  end


  it "should produce gravatar url" do
    user = Factory(:user, :email => "test@example.com")
    user.gravatar.should include("gravatar.com/avatar/55502f40dc8b7c769880b10874abc9d0.jpg")      
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
