class ConvoUsersController < ApplicationController

  before_filter :authenticate_user!

  layout "convo_two_panels"

  respond_to :html, :json

  def index
    @users = current_convo.users
    respond_with @users do |format|
      format.html { render :layout => "convo_one_panel" }
    end
  end

  def manage
    if !current_convo.manageable_by_user?(current_user)
        redirect_to current_convo, :alert => "You can't manage this convo."
    else
      @users = current_convo.users
      respond_with @users
    end
  end

  private

  def current_convo
    current_convo ||= Convo.find(params[:convo_id])
  end

end
