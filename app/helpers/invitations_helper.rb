module InvitationsHelper
  def invitation_link(args)
    convo       = args[:convo]    
    user        = args[:user]    
    unless user.invitations.exists?(:convo_id => @convo.id)
      # the followership id is really does not matter that's why it's 0. The followership entity will be resolved by a leader id in con text of a current user
      link_to "invite", invitations_path(:convo_id => convo.id, :user_id => user.id), :method=>:post, :class => 'button-small-blue'
    end
  end
end