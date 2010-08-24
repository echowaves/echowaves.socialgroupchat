module Gravatarify::Helper
  include Gravatarify::Base
      
  # Helper method for HAML to return a neat hash to be used as attributes in an image tag.
  #
  # Now it's as simple as doing something like:
  #
  #    %img{ gravatar_attrs(@user.mail, :size => 20) }/
  #
  # This is also the base method for +gravatar_tag+.
  #
  # @param [String, #email, #mail, #gravatar_url] email a string or an object used
  #        to generate to gravatar url for.
  # @param [Symbol, Hash] *params other gravatar or html options for building the resulting
  #        hash.
  # @return [Hash] all html attributes required to build an +img+ tag.
  def gravatar_attrs(email, *params)
    url_options = Gravatarify::Utils.merge_gravatar_options(*params)
    options = url_options[:html] || {}
    options[:src] = gravatar_url(email, false, url_options)
    options[:width] = options[:height] = (url_options[:size] || 80) # customize size    
    { :alt => '' }.merge!(options) # to ensure validity merge with :alt => ''!
  end
  
  # Takes care of creating an <tt><img/></tt>-tag based on a gravatar url, it no longer
  # makes use of any Rails helper, so is totally useable in any other library.
  #
  # @param [String, #email, #mail, #gravatar_url] email a string or an object used
  #        to generate the gravatar url from
  # @param [Symbol, Hash] *params other gravatar or html options for building the resulting
  #        image tag.
  # @return [String] a complete and hopefully valid +img+ tag.
  def gravatar_tag(email, *params)
    html_attrs = gravatar_attrs(email, *params).map { |key,value| "#{key}=\"#{CGI.escapeHTML(value.to_s)}\"" }.sort.join(" ")
    Gravatarify::Utils.make_html_safe_if_available("<img #{html_attrs} />");
  end
end