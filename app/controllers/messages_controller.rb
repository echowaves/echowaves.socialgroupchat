class MessagesController < ApplicationController
  before_filter :current_convo
  before_filter :authenticate_user!, :only => [:create]

  def index
    @messages = @convo.messages
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @messages }
      format.json { render :json => @messages }
    end
  end

  def create
    @message = Message.new(:convo => @convo, :user => current_user, :body => params[:text], :uuid =>  params[:uuid])
    respond_to do |format|
      format.js do
        if @message.save
          Pusher["convos-#{@convo.id}"].trigger('message-create', { :text => params[:text],
                                                  :uuid => params[:uuid],
                                                  :gravatar_url => params[:gravatar_url] })
        end
        render :nothing => true
      end
    end
  end


  def show
  end


private

  def current_convo
    @convo = Convo.criteria.id(params[:convo_id])[0]
  end

end
