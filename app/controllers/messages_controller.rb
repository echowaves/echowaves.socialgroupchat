class MessagesController < ApplicationController
  before_filter :current_convo
  before_filter :authenticate_user!, :only => [:create]

  respond_to :html, :json, :xml, :except => :create

  def index
    @raw_messages = @convo.messages
    @messages = @raw_messages.collect{|m| {:uuid => m.uuid, :id => m.id, :text => m.body, :gravatar_url => m.user.gravatar }}
    respond_with @messages do |format|
      format.html { redirect_to convo_url(@convo) }
    end
  end

  def create
    @message = Message.create(:convo => @convo, :user => current_user, :body => params[:text], :uuid =>  params[:uuid])
    respond_with([@convo, @message]) do |format|
      format.js do
        Socky.send({ :text => params[:text],
                     :uuid => params[:uuid],
                     :gravatar_url => params[:gravatar_url] }.to_json,
                     :channels => "convo_#{@convo.id}" )
        render :nothing => true
      end
    end
  end

private

  def current_convo
    @convo = Convo.find(params[:convo_id])
  end

end
