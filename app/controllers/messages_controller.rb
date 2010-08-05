class MessagesController < ApplicationController
  before_filter :current_convo

  def index
    @messages = @convo.messages
  end


  def create
    respond_to do |format|
      format.js do
        Pusher['test_echowaves'].trigger('message-create', { :message => params[:message], :uuid => params[:uuid] })
        render :nothing => true
      end
    end
  end


private
  def current_convo    
    @convo = Convo.criteria.id(params[:convo_id])[0]
  end

end
