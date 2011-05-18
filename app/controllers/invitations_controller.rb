class InvitationsController < ApplicationController
  before_filter :authenticate_user!

  respond_to :html, :json, :xml

  def index
    @convos = current_user.convo_invites
    respond_with(@convos, :layout => false )
  end

  def new
    @convo = Convo.where(:id => params[:convo_id]).first
    @followers = current_user.followers - @convo.subscribers 
  end

  def create
    @invitation = 
    Invitation.new(
    :user_id => params[:user_id], 
    :convo_id => params[:convo_id], 
    :requestor_id => current_user.id)

    if @invitation.save
      redirect_to :back, :notice => 'Invitation sent.' 
    else
      redirect_to :back, :notice => 'Unable to send invitation.' 
    end
  end

  def accept
    @invitation = Invitation.find params[:invitation_id]
    if @invitation.user == current_user
      @invitation.convo.subscribe(current_user)
      # and lets cleanup
      @invitation.destroy
      redirect_to :back, :notice => 'Invitation accepted, subscribed to convo.'
    else
      redirect_to :back, :notice => 'Error accepting invitation.'
    end
  end

  def destroy
    @invitation = Invitation.find params[:id]
    if @invitation.user == current_user
      @invitation.destroy
      redirect_to :back, :notice => 'Invitation cancelled.'
    else
      redirect_to :back, :notice => 'Error cancelling invitation.'
    end
  end
end
