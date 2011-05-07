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

end
