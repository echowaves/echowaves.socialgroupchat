module UsersHelper
  def follow_or_unfollow_link(args)
    follower = args[:follower]
    leader = args[:leader]
    if follower.follows? leader
      link_to "unfollow", unfollow_user_path(leader), :method=>:put, :class => 'button-small-red'
    else
      link_to "follow", follow_user_path(leader), :method=>:put, :class => 'button-small-blue'
    end
  end
end
