module UsersHelper
  def follow_or_unfollow_link(args)
    follower     = args[:follower]
    leader       = args[:leader]    
    if follower.follows? leader
      # the followership id is really does not matter that's why it's 0. The followership entity will be resolved by a leader id in con text of a current user
      link_to "unfollow", user_followership_path(leader.id, 0), :method=>:delete, :class => 'button-small-red' 
    else
      link_to "follow", user_followerships_path(leader.id), :method=>:post, :class => 'button-small-blue'
    end
  end
end
