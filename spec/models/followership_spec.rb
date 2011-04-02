require 'spec_helper'

describe Followership do
  describe "mongoid-rspec" do
    it { should have_fields(:created_at, :updated_at).of_type(Time) }

    it { should be_referenced_in :user }
    it { should embed_one :follower }
  end


end
