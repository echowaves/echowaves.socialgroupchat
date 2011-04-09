require 'spec_helper'

describe Visit do
  describe "mongoid-rspec" do
    it { should have_fields(:created_at, :updated_at).of_type(Time) }
    it { should be_referenced_in :convo }
    it { should be_embedded_in :user }

  end



end
