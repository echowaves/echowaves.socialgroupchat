module SubscriptionsHelper
  def subscribe_or_unsubscribe_link(args)
    convo = args[:convo]
    user  = args[:user]
    if convo.accesible_by_user? user
      if convo.subscribers.include? current_user
        # yakes, passing 0 for subscription_id, little faster, will resolve the subscription by convo_id/user_id
        link_to "unsubscribe", subscription_path(0, :convo_id => convo.id, :user_id => current_user.id), :method => :delete, :class => 'button-small-red'
      else
        link_to "subscribe", subscriptions_path(:convo_id => convo.id, :user_id => current_user.id), :method => :post, :class => 'button-small-blue'
      end
    end
  end
end