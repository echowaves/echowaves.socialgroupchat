require 'spec_helper'

describe Followership do

  describe "remarkable" do
    before(:each) do
      @followership = Factory(:followership)
    end

    # columns
    #----------------------------------------------------------------------
    #  id          :integer         not null, primary key
    #  leader_id   :integer
    #  follower_id :integer
    #  created_at  :datetime
    #  updated_at  :datetime
    it { should have_column :leader_id, :type => :integer, :null => false }

  end

end
