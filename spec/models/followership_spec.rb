require 'spec_helper'

describe Followership do

  describe "remarkable" do
    before(:each) do
      @followership = Factory(:followership)
    end

    # columns
    #----------------------------------------------------------------------
    it { should have_column :leader_id,   :type => :integer, :null => false } 
    it { should have_column :follower_id, :type => :integer, :null => false } 
    it { should have_column :created_at, :type => :datetime } 
    it { should have_column :updated_at, :type => :datetime }

    # indexes
    #----------------------------------------------------------------------
    it { should have_index :leader_id }
    it { should have_index :follower_id }
    it { should have_index :created_at }

    # validations
    #----------------------------------------------------------------------
    it { should validate_presence_of :leader_id }
    it { should validate_presence_of :follower_id }
    it { should validate_uniqueness_of :leader_id, :scope => :follower_id }
 
    # associations
    #----------------------------------------------------------------------
    it { should belong_to :leader,     :class_name => "User" }
    it { should belong_to :follower,   :class_name => "User" } 
  end
  
  describe "followers logic" do
    before do
      @follower = Factory(:user)
      @leader = Factory(:user)
    end
    
    it "should be able to follow" do
      @leader.should_not be_followed(@follower)
      @follower.follow(@leader)
      @leader.should be_followed(@follower)
    end
  
    it "should be able to unfollow" do
      @follower.follow(@leader)
      @leader.should be_followed(@follower)
      @follower.unfollow(@leader)
      @leader.should_not be_followed(@follower)      
    end
   end

end
