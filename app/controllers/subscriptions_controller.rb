class SubscriptionsController < ApplicationController

  respond_to :html, :json, :xml
  ################################################################################
  # subscriptions GET   /subscriptions(.:format)?convo_id=:convo_id&user_id=:user_id
  ################################################################################
  # will give @subscriptions collection either per convo or per user
  def index
    @subscriptions = @convo.subscriptions.page(params[:page]) if convo
    @subscriptions = @user .subscriptions.page(params[:page]) if user
  end

  ################################################################################
  # subscriptions POST   /convos/:convo_id/subscriptions(.:format)     
  ################################################################################
  # The current user follows a conversation.
  def create
    if convo.accesible_by_user?(user)
      convo.subscribe(user)
      redirect_to :back, :notice => 'You are subscribed to the conversation.' 
    else
      redirect_to :back, :notice => "Sorry, but you can't access this conversation." 
    end
  end

  ################################################################################
  # subscription DELETE /subscriptions/:id(.:format)?convo_id=:convo_id&user_id=:user_id
  # NOTE: the subscription_id is going to be ignored, pass 0
  ################################################################################
  # only the owner of the convo can unsubsribe any subscriber, or the subscriber can unsubscribe only themselve
  def destroy
    if (current_user == convo.owner || (subscription && current_user == subscription.user) )
      convo.unsubscribe(user)
      redirect_to(:back, :notice => 'Unsubscribed from the conversation.')
    else
      redirect_to(:back, :notice => 'Unable to unsubscribe.')
    end
  end

  private
  def convo
    @convo ||= Convo.find(params[:convo_id]) if params[:convo_id]
  end
  def user
    @user ||= User.find(params[:user_id]) if params[:user_id]
  end
  def subscription 
    @subscription ||= user.subscriptions.where(:convo_id => convo.id).first if (user&&convo)
  end

end
