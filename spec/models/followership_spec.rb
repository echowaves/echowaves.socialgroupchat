require 'spec_helper'

describe Followership do

  describe "remarkable" do
    before(:each) do
      @followership = Factory(:followership)
    end

    # columns
    #----------------------------------------------------------------------
    it { should have_db_column(:leader_id).of_type(:integer).with_options(:null => false) } 
    it { should have_db_column(:follower_id).of_type(:integer).with_options(:null => false) } 
    it { should have_db_column(:created_at).of_type(:datetime) } 
    it { should have_db_column(:updated_at).of_type(:datetime) }

    # indexes
    #----------------------------------------------------------------------
    it { should have_db_index :leader_id }
    it { should have_db_index :follower_id }
    it { should have_db_index :created_at }

    # validations
    #----------------------------------------------------------------------
    it { should validate_presence_of :leader_id }
    it { should validate_presence_of :follower_id }
    it { should validate_uniqueness_of(:leader_id).scoped_to(:follower_id) }
 
    # associations
    #----------------------------------------------------------------------
    it { should belong_to :leader }
    it { should belong_to :follower } 
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
      # expressing the same relation bu differently
      @follower.follows?(@leader).should == true
      #double check that it creates the relationship only on one side
      @follower.should_not be_followed(@leader)
      @leader.follows?(@follower).should == false
    end
  
    it "should be able to unfollow" do
      @follower.follow(@leader)
      @leader.should be_followed(@follower)
      @follower.unfollow(@leader)
      @leader.should_not be_followed(@follower)      
    end
   end

end
