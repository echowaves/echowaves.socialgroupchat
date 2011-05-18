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
      
    respond_to do |format|
      if @invitation.save
        format.html { redirect_to :back, :notice => 'Invitation sent.' } 
      else
        format.html { redirect_to :back, :notice => 'Unable to send invitation.' }         
      end
    end
    
  end

end
