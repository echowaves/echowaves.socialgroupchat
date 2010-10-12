require "yaml"
require 'websocket'
require 'socky/java_script_generator'

module Socky
  CONFIG = YAML::load(ERB.new(IO.read(Rails.root.join("config","socky_hosts.yml"))).result).freeze

  class << self

    def send(*args, &block)
      options = normalize_options(*args, &block)
      send_message(options.delete(:data), options)
    end

    def show_connections
      send_query(:show_connections)
    end

    def hosts
      CONFIG[:hosts]
    end

    def random_host
      hosts[rand(hosts.size)] # Rails 3 break Array#rand()
    end

    def deprecation_warning(msg)
      Rails.logger.warn "DEPRECATION WARNING: " + msg.to_s
    end

  private

    def normalize_options(data = nil, options = {}, &block)
      case data
        when NilClass
          options[:data] = JavaScriptGenerator.new(&block).to_s unless block.nil?
        when Hash
          options, data = data, nil
          options[:data] = JavaScriptGenerator.new(&block).to_s unless block.nil?
        when String, Symbol
          data = data.to_s
          options[:data] = data
      else
        options.merge!(:data => data.to_s)
      end

      options[:data] = options[:data].to_s
      options
    end

    def send_message(data, opts = {})
      to = opts[:to] || {}
      except = opts[:except] || {}

      unless to.is_a?(Hash) && except.is_a?(Hash)
        puts "recipiend data should be in hash format"
        return
      end

      to_clients = to[:client] || to[:clients]
      to_channels = to[:channel] || to[:channels]
      except_clients = except[:client] || except[:clients]
      except_channels = except[:channel] || except[:channels]

      # If clients or channels are non-nil but empty then there's no users to target message
      return if (to_clients.is_a?(Array) && to_clients.empty?) || (to_channels.is_a?(Array) && to_channels.empty?)

      hash = {
        :command  => :broadcast,
        :body     => data,
        :to => {
          :clients  => to_clients,
          :channels => to_channels,
        },
        :except => {
          :clients  => except_clients,
          :channels => except_channels,
        }
      }

      [:to, :except].each do |type|
        hash[type].reject! { |key,val| val.nil? || (type == :except && val.empty?)}
        hash.delete(type) if hash[type].empty?
      end

      send_data(hash)
    end

    def send_query(type)
      hash = {
        :command  => :query,
        :type     => type
      }
      send_data(hash, true)
    end


    def send_data(hash, response = false)
      res = []
      hosts.each do |address|
        begin
          scheme = (address[:secure] ? "wss" : "ws")
          @socket = WebSocket.new("#{scheme}://#{address[:host]}:#{address[:port]}/?admin=1&client_secret=#{address[:secret]}")
          @socket.send(hash.to_json)
          res << @socket.receive if response
        rescue
          puts "ERROR: Connection to server at '#{scheme}://#{address[:host]}:#{address[:port]}' failed"
        ensure
          @socket.close if @socket && !@socket.tcp_socket.closed?
        end
      end
      res.collect {|r| ActiveSupport::JSON.decode(r)["body"] } if response
    end

  end
end