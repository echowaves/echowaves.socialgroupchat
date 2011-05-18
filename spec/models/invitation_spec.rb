require 'spec_helper'

describe Invitation do

  describe "remarkable" do
    before(:each) do
      @invitation = Factory(:invitation)
    end

    # columns
    #----------------------------------------------------------------------
    it { should have_column :convo_id, :type  => :integer, :null => false }
    it { should have_column :user_id, :type  => :integer, :null => false }
    it { should have_column :requestor_id, :type  => :integer, :null => false }
    it { should have_column :created_at, :type => :datetime }
    it { should have_column :updated_at, :type => :datetime }

    # indexes
    #----------------------------------------------------------------------
    it { should have_index :convo_id }
    it { should have_index :user_id }
    it { should have_index :requestor_id }
    it { should have_index :created_at }

    # validations
    #----------------------------------------------------------------------
    it { should validate_presence_of :convo }
    it { should validate_presence_of :user }
    it { should validate_presence_of :requestor }
    it { should validate_uniqueness_of :convo_id, :scope => :user_id }

    # associations
    #----------------------------------------------------------------------
    it { should belong_to :convo }
    it { should belong_to :user }
    it { should belong_to :requestor, class_name: "User" }
    #----------------------------------------------------------------------

  end
  
end
