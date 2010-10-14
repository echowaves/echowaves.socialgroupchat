class UsersController < ApplicationController

  respond_to :html, :json, :xml

  def index
    @users = User.desc(:created_at).paginate(:page => params[:page], :per_page => 20)
    respond_with @users
  end

  def show
    @user = User.find(params[:id])
    respond_with(@user) do |format|
      format.html { }
    end
  end

end
