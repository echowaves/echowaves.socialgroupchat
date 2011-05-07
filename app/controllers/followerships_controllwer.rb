class FollowershipsController < ApplicationController

  respond_to :html, :json, :xml

  def create
    respond_to do |format|
      current_user.follow user
      format.html { redirect_to :back, :notice => 'You followed the user.' }
    end
  end


  def destroy
    respond_to do |format|
      current_user.unfollow user
      format.html { redirect_to :back, :notice => 'You unfollowed the user.' }
    end
  end
  
  
  
  
  private
  def user
    @user ||= User.find(params[:id])
  end
  

end
