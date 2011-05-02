class UpdatesController < ApplicationController
  before_filter :authenticate_user!

  respond_to :html, :json, :xml

  def index
    @subscriptions = current_user.updated_subscriptions
    respond_with @subscriptions
  end

end
