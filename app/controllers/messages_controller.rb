class MessagesController < ApplicationController

  def create
    respond_to do |format|
      format.js do
        Pusher['test_echowaves'].trigger('message-create', { :message => params[:message], :uuid => params[:uuid] })
        render :nothing => true
      end
    end
  end

end
