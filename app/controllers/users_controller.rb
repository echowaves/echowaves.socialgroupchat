class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [:index]

  respond_to :html, :json, :xml

  def index
    @users = User.order("created_at DESC").page(params[:page])
    respond_with @users
  end


  def show
    respond_with(user) do |format|
      if(user == current_user)
        # only want to respond in html
        format.html { }
      else
        format.html { redirect_to :back, :notice => 'This is not your profile, you can\'t see it.' }      
      end
    end
  end


  private
  def user
    @user ||= User.find(params[:id])
  end


end
