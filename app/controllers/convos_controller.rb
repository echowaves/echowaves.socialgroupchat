class ConvosController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]

  # GET /convos
  # GET /convos.xml
  def index
    @convos = Convo.all

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

  # GET /convos/new
  # GET /convos/new.xml
  def new
    @convo = Convo.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @convo }
    end
  end

  # GET /convos/1/edit
  def edit
    @convo = Convo.find(params[:id])
  end

  # POST /convos
  # POST /convos.xml
  def create
    @convo = Convo.new(params[:convo])

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

  # PUT /convos/1
  # PUT /convos/1.xml
  def update
    @convo = Convo.find(params[:id])

    respond_to do |format|
      if @convo.update_attributes(params[:convo])
        format.html { redirect_to(@convo, :notice => 'Convo was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @convo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /convos/1
  # DELETE /convos/1.xml
  def destroy
    @convo = Convo.find(params[:id])
    @convo.destroy

    respond_to do |format|
      format.html { redirect_to(convos_url) }
      format.xml  { head :ok }
    end
  end
end
