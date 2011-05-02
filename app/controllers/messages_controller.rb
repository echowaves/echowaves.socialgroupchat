class MessagesController < ApplicationController
  before_filter :authenticate_user!, :only => [:create]

  respond_to :html, :json, :xml, :except => :create

  def index
    @raw_messages = current_convo.messages
    @messages = @raw_messages.collect{|m| {:uuid => m.uuid, :id => m.id, :text => m.body, :gravatar_url => m.owner.gravatar }}
    respond_with @messages do |format|
      format.html { redirect_to convo_url(current_convo) }
    end
  end

  def create
    @message = Message.create(:convo => current_convo, :owner => current_user, :body => params[:text], :uuid =>  params[:uuid])
    respond_with([current_convo, @message]) do |format|
      format.js do
        Socky.send({ :text => params[:text],
                     :uuid => params[:uuid],
                     :gravatar_url => params[:gravatar_url] }.to_json,
                     :channels => "convo_#{current_convo.id}" )
        current_user.visit current_convo # make sure to reset stats for this current convo
        render :nothing => true
      end
    end
  end

private

  def current_convo
    @current_convo ||= Convo.find(params[:convo_id])
  end

end
