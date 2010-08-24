require 'digest/md5'
require 'cgi'

module Gravatarify
  # Hash of :ultra_long_option_name => :abbr_opt
  GRAVATAR_ABBREV_OPTIONS = { 'default' => :d, :default => :d, 'rating' => :r, :rating => :r, 'size' => :s, :size => :s }
  
  class << self
    
    # Global options which are merged on every call to
    # +gravatar_url+, this is useful to e.g. define a default image.
    #
    # When using Rails defining default options is best done in an
    # initializer +config/initializers/gravatarify.rb+ (or similar).
    #
    # Usage examples:
    #
    #     # set the default image using a Proc
    #     Gravatarify.options[:default] = Proc.new { |*args| "http://example.com/avatar-#{args.first[:size] || 80}.jpg" }
    #
    #     # or set a custom default rating
    #     Gravatarify.options[:rating] = :R
    #
    #     # or disable adding an extension
    #     Gravatarify.options[:filetype] = false
    #
    def options; @options ||= { :filetype => :jpg } end
  
    # Allows to define some styles, makes it simpler to call by name, instead of always giving a size etc.
    # 
    #   Gravatarify.styles[:mini] => { :size => 30, :default => "http://example.com/gravatar-mini.jpg" }
    # 
    #   # in the views, it will then use the stuff defined by styles[:mini]:
    #   <%= gravatar_tag @user, :mini %>
    #
    def styles; @styles ||= {} end
    
    # Globally overide subdomains used to build gravatar urls, normally
    # +gravatarify+ picks from either +0.gravatar.com+, +1.gravatar.com+,
    # +2.gravatar.com+ or +www.gravatar.com+ when building hosts, to use a custom
    # set of subdomains (or none!) do something like:
    #
    #     Gravatarify.subdomains = %w{ 0 www } # only use 0.gravatar.com and www.gravatar.com
    #
    def subdomains=(subdomains) @subdomains = [*subdomains] end
    
    # Get subdomain for supplied string or returns +www+ if none is
    # defined.
    def subdomain(str) #:nodoc:
      @subdomains ||= %w{ 0 1 2 www }
      (@subdomains.empty? ? nil : @subdomains[str.hash % @subdomains.size]) || 'www'
    end
  end
  
  # Provides core support to build gravatar urls based on supplied e-mail strings.
  module Base
    
    # Method which builds a gravatar url based on a supplied email and options as
    # defined by gravatar.com (http://en.gravatar.com/site/implement/url).
    #
    #    gravatar_url('peter.gibbons@initech.com', :size => 16) # => "http://0.gravatar.com/avatar/cb7865556d41a3d800ae7dbb31d51d54.jpg?s=16"
    #
    # It supports multiple gravatar hosts (based on email hash), i.e. depending
    # on the hash, either <tt>0.gravatar.com</tt>, <tt>1.gravatar.com</tt>, <tt>2.gravatar.com</tt> or <tt>www.gravatar.com</tt>
    # is used.
    #
    # If supplied +email+ responds to either a method named +email+ or +mail+, the value of that method
    # is used instead to build the gravatar hash. Very useful to just pass in ActiveRecord object for instance:
    #    
    #    @user = User.find_by_email("samir@initech.com")
    #    gravatar_url(@user) # => "http://2.gravatar.com/avatar/58cf31c817d76605d5180ce1a550d0d0.jpg"
    #    gravatar_url(@user.email) # same as above!
    # 
    # Among all options as defined by gravatar.com's specification, there also exist some special options:
    #
    #    gravatar_url(@user, :secure => true) # => https://secure.gravatar.com/ava....
    #
    # Useful when working on SSL enabled sites. Of course often used options should be set through
    # +Gravatarify.options+.
    #
    # @param [String, #email, #mail] email a string representing an email, or object which responds to +email+ or +mail+
    # @param [Symbol, Hash] *params customize generated gravatar.com url. First argument can also be a style.
    # @option url_options [String, Proc] :default (nil) URL of an image to use as default when no gravatar exists. Gravatar.com
    #                                    also accepts special values like +identicon+, +monsterid+ or +wavater+ which just displays
    #                                    a generic icon based on the hash or <tt>404</tt> which return a HTTP Status 404.
    # @option url_options [String, Symbol] :rating (:g) Specify the rating, gravatar.com supports <tt>:g</tt>, <tt>:pg</tt>,
    #                                     <tt>:r</tt> or <tt>:x</tt>, they correspond to movie ratings :)
    # @option url_options [Integer] :size (80) The size of the (square) image.
    # @option url_options [Boolean, Proc] :secure (false) If set to +true+, then uses the secure gravatar.com URL. If a Proc is
    #                                     supplied it's evaluated, the Proc should evaluate to +true+ or +false+.
    # @option url_options [String, Symbol] :filetype (:jpg) Gravatar.com supports only <tt>:gif</tt>, <tt>:jpg</tt> and <tt>:png</tt>.
    #                                      if an set to +false+, +nil+ or an empty string no extension is added.
    # @return [String] In any case (even if supplied +email+ is +nil+) returns a fully qualified gravatar.com URL.
    #                  The returned string is not yet HTML escaped, *but* all +url_options+ have been URI escaped.
    def gravatar_url(email, *params)
      url_options = Utils.merge_gravatar_options(*params)
      email_hash = Digest::MD5.hexdigest(Utils.smart_email(email))
      extension = (ext = url_options.delete(:filetype) and ext != '') ? ".#{ext || 'jpg'}" : '' # slightly adapted from gudleik's implementation
      host = Base.gravatar_host(self, email_hash, url_options.delete(:secure))
      "#{host}/avatar/#{email_hash}#{extension}#{Base.gravatar_params(email, url_options)}"
    end
    
    # For backwards compatibility.
    alias_method :build_gravatar_url, :gravatar_url
    
    protected
      # Builds gravatar host name from supplied e-mail hash.
      # Ensures that for the same +str_hash+ always the same subdomain is used.
      #
      # @param [String] str_hash email, as hashed string as described in gravatar.com implementation specs
      # @param [Boolean, Proc] secure if set to +true+ then uses gravatars secure host (<tt>https://secure.gravatar.com</tt>),
      #        else that subdomain magic. If it's passed in a +Proc+, it's evaluated and the result (+true+/+false+) is used
      #        for the same decicion.
      # @return [String] Protocol and hostname (like <tt>http://www.gravatar.com</tt>), without trailing slash.
      def self.gravatar_host(context, str_hash, secure = false)        
        use_ssl_host = secure.is_a?(Proc) ? secure.call(context) : secure
        use_ssl_host ? "https://secure.gravatar.com" : "http://#{Gravatarify.subdomain(str_hash)}.gravatar.com"        
      end
        
      # Builds a query string from all passed in options.
      def self.gravatar_params(source, url_options = {})
        params = url_options.inject([]) do |params, (key, value)|
          key = (GRAVATAR_ABBREV_OPTIONS[key] || key).to_sym # shorten & symbolize key
          unless key == :html
            value = value.call(url_options, source) if key == :d and value.is_a?(Proc)
            params << "#{key}=#{CGI.escape(value.to_s)}" if value
          end
          params
        end
        "?#{params.sort * '&'}" unless params.empty?
      end    
  end
end