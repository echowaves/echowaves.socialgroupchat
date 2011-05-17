class InvitationsController < ApplicationController
  before_filter :authenticate_user!

  respond_to :html, :json, :xml

  def index
    @convos = current_user.convo_invites
    respond_with(@convos) 
  end

end
