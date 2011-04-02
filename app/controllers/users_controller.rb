class UsersController < ApplicationController

  respond_to :html, :json, :xml

  def index
    @users = User.desc(:created_at).page(params[:page])
    respond_with @users
  end

  def show
    @user = User.find(params[:id])
    respond_with(@user) do |format|
      format.html { }
    end
  end

end
