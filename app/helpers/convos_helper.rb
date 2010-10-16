module ConvosHelper
  def subscribe_or_unsubscribe_link(args)
    convo = args[:convo]
    user = args[:user]
    if convo.users.include? user
      link_to "unsubscribe", unsubscribe_convo_path(convo), :class => 'button-small-red'
    else
      link_to "subscribe", subscribe_convo_path(convo), :class => 'button-small-blue'
    end
  end
end
