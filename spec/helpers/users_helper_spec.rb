require 'spec_helper'

describe UsersHelper do
  before do
    @leader = Factory(:user)
    @follower = Factory(:user)
  end
  it "creates follow link if the user is not yet followed" do
    content = helper.follow_or_unfollow_link(:leader => @leader, :follower => @follower)
    content.should include ">follow<"
  end
  it "creates unfollow link if the user is already followed" do
    @follower.follow(@leader)
    content = helper.follow_or_unfollow_link(:leader => @leader, :follower => @follower)
    content.should include ">unfollow<"
  end
end
