# this controller is a bit weird, it mixes methods from two different scopes, 
# the index action works in users context, the create and destroy work in convos context
class SubscriptionsController < ApplicationController

  respond_to :html, :json, :xml

  ################################################################################
  # user_subscriptions GET    /users/:user_id/subscriptions(.:format)   
  ################################################################################
  def index
    # @convos = Convo.desc(:created_at).where(:privacy => "public").page(params[:page])
    # FIXME: n+1 query!!!!!!!!!!!!!!!!!!!!!!!!    
    # potentially might be able to retreive all the convo_id from @ssubscriptions collection, then find all the @convos in one queries -- still more then one query (2), but much better then n+1    
    @subscriptions = Subscription.where(:user_id => user_id).order("created_at DESC").page(params[:page])
    @convos = @subscriptions.map(&:convo)
    respond_with @convos
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
  def user_id
    @user_id ||= params[:user_id]    
  end

  def convo
    @convo ||= Convo.find(params[:convo_id])
  end


end
