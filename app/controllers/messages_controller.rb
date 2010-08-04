class MessagesController < ApplicationController

  def index
  end


  def create
    respond_to do |format|
      format.js do
        Pusher['test_echowaves'].trigger('message-create', { :message => params[:message], :uuid => params[:uuid] })
        render :nothing => true
      end
    end
  end

end
