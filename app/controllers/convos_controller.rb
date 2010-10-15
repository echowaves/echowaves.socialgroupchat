class ConvosController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show, :mockup]

  respond_to :html, :json, :xml

  def index
    # here we list only public convos
    @convos = Convo.desc(:created_at).where(:privacy => "public").paginate(:page => params[:page], :per_page => 20)
    respond_with @convos
  end

  def show
    @convo = Convo.find(params[:id])
    respond_with(@convo) do |format|
      if @convo.public? || (current_user && @convo.accesible_by_user?(current_user))
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
        @convo_user = ConvoUser.new :convo => @convo, :user => current_user
        @convo_user.save

        format.html { redirect_to(@convo, :notice => 'Convo was successfully created.') }
        format.xml  { render :xml => @convo, :status => :created, :location => @convo }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @convo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # The current user follows a conversation.
  def follow
    @convo = Convo.find(params[:id])
    if @convo.public?
      ConvoUser.create :convo => @convo, :user => current_user
    end
    redirect_to convo_path(@convo)
  end

end
