require 'spec_helper'

describe Followership do
  describe "mongoid-rspec" do
    it { should have_fields(:created_at, :updated_at).of_type(Time) }

    it { should be_referenced_in :user }
    it { should have_field(:follower_id)}

    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:follower_id) }
  end


  it "should return follower user" do
    @follower = User.make!
    @leader = User.make!
    @follower.follow(@leader)

    @resolved_follower = @leader.followerships[0].follower
    @resolved_follower.should == @follower
  end

end
