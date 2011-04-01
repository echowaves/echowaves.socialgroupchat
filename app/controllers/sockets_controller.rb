class SocketsController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def subscribe
    render :text => "ok"
  end

  def unsubscribe
    render :text => "ok"
  end

  # private
  # 
  # def send_to_clients(data)
  #   Socky.send(data.collect{|d| CGI.escapeHTML(d)}.to_json)
  # end

end
