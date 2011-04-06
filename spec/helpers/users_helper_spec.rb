require 'spec_helper'

describe UsersHelper do
  describe "#follow_or_unfollow_link(:leader, :follower)" do
    it "creates follow link if the user is not yet followed" do
      leader = User.make!
      follower = User.make!
      content = helper.follow_or_unfollow_link(:leader => leader, :follower => follower)
      content.should include ">follow<"
    end
  end 
  it "creates unfollow link if the user is already followed" do
    leader = User.make!
    follower = User.make!
    follower.follow(leader)
    content = helper.follow_or_unfollow_link(:leader => leader, :follower => follower)
    content.should include ">unfollow<"
  end
end
