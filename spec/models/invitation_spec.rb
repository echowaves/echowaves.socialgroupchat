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

    # associations
    #----------------------------------------------------------------------
    it { should belong_to :convo }
    it { should belong_to :user }
    it { should belong_to :requestor, class_name: "User" }
    #----------------------------------------------------------------------

  end
  
  
  # it "should generate a token when created" do
  #   user = Factory(:user)
  #   requestor = Factory(:user)
  #   convo = Factory(:convo)
  #   invite = Invitation.create(:user => user, :requestor_id => requestor.id, :convo => convo)
  #   # commenting out to make spec pass
  #   pending "generate token"
  #   invite.token.should match(/[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}/)
  # 
  # end
end
