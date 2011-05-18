class SubscriptionsController < ApplicationController

  respond_to :html, :json, :xml

  def index
    convo
    @subscriptions = @convo.subscriptions.page(params[:page])
  end

  ################################################################################
  # convo_subscriptions POST   /convos/:convo_id/subscriptions(.:format)     
  ################################################################################
  # The current user follows a conversation.
  def create
    respond_to do |format|
      if convo.accesible_by_user?(current_user)
        convo.subscribe(current_user)
        format.html { redirect_to :back, :notice => 'You are subscribed to the conversation.' }
      else
        format.html { redirect_to :back, :notice => "Sorry, but you can't access this conversation." }
      end
    end
  end

  ################################################################################
  # convo_subscription DELETE /convos/:convo_id/subscriptions/:id(.:format)
  ################################################################################
  # The current user unfollows a conversation.
  def destroy
    respond_to do |format|
      convo.unsubscribe(current_user)
      format.html { redirect_to(:back, :notice => 'You are unsubscribed from the conversation.') }
    end
  end


  private

  def convo
    @convo ||= Convo.find(params[:convo_id])
  end

end
