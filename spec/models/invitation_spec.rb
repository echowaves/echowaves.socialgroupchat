require 'spec_helper'

describe Invitation do

  describe "remarkable" do
    before(:each) do
      @invitation = Factory(:invitation)
    end

    # columns
    #----------------------------------------------------------------------
    it { should have_db_column(:convo_id).of_type(:integer).with_options(:null => false) }
    it { should have_db_column(:user_id).of_type(:integer).with_options(:null => false) }
    it { should have_db_column(:requestor_id).of_type(:integer).with_options(:null => false) }
    it { should have_db_column(:created_at).of_type(:datetime) }
    it { should have_db_column(:updated_at).of_type(:datetime) }

    # indexes
    #----------------------------------------------------------------------
    it { should have_db_index :convo_id }
    it { should have_db_index :user_id }
    it { should have_db_index :requestor_id }
    it { should have_db_index :created_at }

    # validations
    #----------------------------------------------------------------------
    it { should validate_presence_of :convo }
    it { should validate_presence_of :user }
    it { should validate_presence_of :requestor }
    it { should validate_uniqueness_of(:convo_id).scoped_to(:user_id) }

    # associations
    #----------------------------------------------------------------------
    it { should belong_to :convo }
    it { should belong_to :user }
    it { should belong_to :requestor }
    #----------------------------------------------------------------------

  end
  
end
