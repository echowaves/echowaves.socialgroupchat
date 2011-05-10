require 'spec_helper'

describe UsersHelper do
  describe "#follow_or_unfollow_link(:leader, :follower)" do
    it "creates follow link if the user is not yet followed" do
      leader = Factory(:user)
      follower = Factory(:user)
      content = helper.follow_or_unfollow_link(:leader => leader, :follower => follower)
      content.should include ">follow<"
    end
  end 
  it "creates unfollow link if the user is already followed" do
    leader = Factory(:user)
    follower = Factory(:user)
    follower.follow(leader)
    content = helper.follow_or_unfollow_link(:leader => leader, :follower => follower)
    content.should include ">unfollow<"
  end
end
