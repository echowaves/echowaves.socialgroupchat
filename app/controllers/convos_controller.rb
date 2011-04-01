class ConvosController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]

  respond_to :html, :json, :xml

  def index
    # here we list only public convos
    @convos = Convo.where(:privacy => "public").desc(:created_at).paginate(:page => params[:page], :per_page => 20)
    respond_with @convos
  end

  def show
    @convo = Convo.find(params[:id])
    respond_with(@convo) do |format|
      if @convo.accesible_by_user?(current_user)
        format.html { render :layout => 'messages' }
      else
        format.html { redirect_to convos_path, :alert => "Sorry but this convo is private" }
      end
    end
  end

  def new
    @convo = Convo.new
    respond_with(@convo)
  end

  def create
    @convo = Convo.new(params[:convo])
    @convo.user = current_user
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

  # The current user follows a conversation.
  def subscribe
    @convo = Convo.find(params[:id])
    respond_to do |format|
      if @convo.accesible_by_user?(current_user)
        @convo.add_user(current_user)
        format.html { redirect_to(@convo, :notice => 'You are subscribed to the conversation.') }
      else
        format.html { redirect_to @convo, :notice => "Sorry, but you can't access this conversation." }
      end
    end
  end

  # The current user unfollows a conversation.
  def unsubscribe
    @convo = Convo.find(params[:id])
    respond_to do |format|
      @convo.remove_user(current_user)
      format.html { redirect_to(convos_path, :notice => 'You are unsubscribed from the conversation.') }
    end
  end

end
