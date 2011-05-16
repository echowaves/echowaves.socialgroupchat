class ConvosController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]

  respond_to :html, :json, :xml

  def index
    # here we list only public convos
    @convos = Convo.where(:privacy_level => 1).order("created_at DESC").page(params[:page])
    respond_with @convos
  end

  def show    
    respond_with(convo) do |format|
      if convo.accesible_by_user?(current_user)
        current_user.visit convo if user_signed_in?        
        format.html { render :layout => 'messages' }
      else
        format.html { redirect_to convos_path, :alert => "Sorry but this convo is confidential." }
      end
    end
  end

  def new
    @convo = Convo.new
    respond_with(@convo)
  end

  def create
    @convo = Convo.new(params[:convo])
    @convo.owner = current_user
    respond_to do |format|
      if @convo.save
        format.html { redirect_to(@convo, :notice => 'Convo was successfully created.') }
        format.xml  { render :xml => @convo, :status => :created, :location => @convo }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @convo.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  private
  def convo
    @convo ||= Convo.find(params[:id])
  end
  
end
