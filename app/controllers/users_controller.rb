class UsersController < ApplicationController

  respond_to :html, :json, :xml

  def index
    @users = User.desc(:created_at).page(params[:page])
    respond_with @users
  end


  def show
    respond_with(user) do |format|
      format.html { }
    end
  end


  def follow
    respond_to do |format|
      current_user.follow user
      format.html { redirect_to :back, :notice => 'You followed the user.' }
    end
  end


  def unfollow
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
