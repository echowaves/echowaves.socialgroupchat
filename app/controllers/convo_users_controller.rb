class ConvoUsersController < ApplicationController

  before_filter :authenticate_user!
  before_filter :find_convo

  layout "convo_two_panels"

  respond_to :html, :json

  def index
    @users = @convo.users
    respond_with @users do |format|
      format.html { render :layout => "convo_one_panel" }
    end
  end

  def manage
    require_admin
    @users = @convo.users
    respond_with @users
  end

  private

  def find_convo
    @convo = Convo.find(params[:convo_id])
  end

  def require_admin
    if !@convo.manageable_by_user?(current_user)
      format.html { redirect_to convo_path(@convo), :alert => "You can't manage this convo" }
    end
  end

end
