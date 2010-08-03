class ConvosController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]

  # GET /convos
  # GET /convos.xml
  def index
    # here we list only public convos
    @convos = Convo.desc(:created_at).where(:privacy => "public").paginate(:page => params[:page], :per_page => 20)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @convos }
    end
  end

  # GET /convos/1
  # GET /convos/1.xml
  def show
    @convo = Convo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @convo }
    end
  end

  def mockup
    respond_to do |format|
      format.html { render :layout => 'convo' }
    end
  end

  # GET /convos/new
  # GET /convos/new.xml
  def new
    @convo = Convo.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @convo }
    end
  end


  # POST /convos
  # POST /convos.xml
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

end
