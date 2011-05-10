class FollowershipsController < ApplicationController
  before_filter :authenticate_user!

  respond_to :html, :json, :xml

  def create
    current_user.follow user
    respond_to do |format|
      format.html { redirect_to :back, :notice => 'You followed the user.' }
    end
  end

  def destroy
    current_user.unfollow user
    respond_to do |format|
      format.html { redirect_to :back, :notice => 'You unfollowed the user.' }
    end
  end
  
  private
  def user
    @user ||= User.find(params[:user_id])
  end
  

end
