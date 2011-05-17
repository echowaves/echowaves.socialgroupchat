class InvitationsController < ApplicationController
  before_filter :authenticate_user!

  respond_to :html, :json, :xml

  def index
    @convos = current_user.convo_invites
    respond_with(@convos, :layout => false )
  end

  def new
    @convo = Convo.where(:id => params[:convo_id]).first
    @convo.invitations.build
    @followers = current_user.followers - @convo.users
  end

end
