require 'spec_helper'

describe Visit do
  describe "remarkable" do
    before(:each) do
      @visit = Factory(:visit)
    end 

    # columns
    #----------------------------------------------------------------------
    it { should have_column :user_id,  :type => :integer, :null => false }
    it { should have_column :convo_id, :type => :integer, :null => false }
    it { should have_column :created_at, :type => :datetime }
    it { should have_column :updated_at, :type => :datetime }

    # indexes
    #----------------------------------------------------------------------
    it { should have_index :user_id }
    it { should have_index :convo_id }
    it { should have_index :created_at }
        
    # validations
    #----------------------------------------------------------------------
    it { should validate_presence_of :user_id }
    it { should validate_presence_of :convo_id }
    it { should validate_uniqueness_of :user_id, :scope => :convo_id }
        
    # associations
    #----------------------------------------------------------------------
    it { should belong_to :user }
    it { should belong_to :convo }
    
  end
end
