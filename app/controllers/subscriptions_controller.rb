class SubscriptionsController < ApplicationController

  respond_to :html, :json, :xml

  def index
    # @convos = Convo.desc(:created_at).where(:privacy => "public").page(params[:page])
    # FIXME: n+1 query!!!!!!!!!!!!!!!!!!!!!!!!    
    # potentially might be able to retreive all the convo_id from @ssubscriptions collection, then find all the @convos in one queries -- still more then one query (2), but much better then n+1    
    @subscriptions = Subscription.desc(:created_at).where(:user_id => user_id).page(params[:page])
    @convos = @subscriptions.map(&:convo)
    respond_with @convos
  end

  private
  def user_id
    @user_id ||= params[:user_id]    
  end

end
