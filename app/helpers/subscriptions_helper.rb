module SubscriptionsHelper
  def subscribe_or_unsubscribe_link(args)
    convo = args[:convo]
    if convo.users.include? current_user
      link_to "unsubscribe", convo_subscription_path(convo, 0), :method=>:delete, :class => 'button-small-red'
    else
      link_to "subscribe", convo_subscriptions_path(convo), :method=>:post, :class => 'button-small-blue'
    end
  end
end