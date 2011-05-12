module UsersHelper
  def follow_or_unfollow_link(args)
    follower     = args[:follower]
    leader       = args[:leader]    
    if follower.follows? leader
      link_to "unfollow", user_followership_path(leader.id, 0), :method=>:delete, :class => 'button-small-red'
    else
      link_to "follow", user_followerships_path(leader.id), :method=>:post, :class => 'button-small-blue'
    end
  end
end
