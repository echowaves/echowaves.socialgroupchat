class SubscriptionsController < ApplicationController

  respond_to :html, :json, :xml

  def index
    @user_id = params[:user_id]    
    # @convos = Convo.desc(:created_at).where(:privacy => "public").paginate(:page => params[:page], :per_page => 20)
    # FIXME: n+1 query!!!!!!!!!!!!!!!!!!!!!!!!    
    # potentially might be able to retreive all the convo_id from @ssubscriptions collection, then find all the @convos in one queries -- still more then one query (2), but much better then n+1    
    @subscriptions = Subscription.desc(:created_at).where(:user_id => @user_id).paginate(:page => params[:page], :per_page => 20)
    @convos = @subscriptions.map { |s| s.convo }
    respond_with @convos
  end

end
