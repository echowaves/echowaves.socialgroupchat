class VisitsController < ApplicationController
  before_filter :authenticate_user!

  respond_to :html, :json, :xml

  def index
    # @messages = @raw_messages.collect{|m| {:uuid => m.uuid, :id => m.id, :text => m.body, :gravatar_url => m.user.gravatar }}
    # respond_with @messages do |format|
    #   format.html { redirect_to convo_url(@convo) }
    # end
  end


end
