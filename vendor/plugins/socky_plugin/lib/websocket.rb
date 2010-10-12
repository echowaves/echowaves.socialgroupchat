# Copyright: Hiroshi Ichikawa <http://gimite.net/en/>
# Lincense: New BSD Lincense
# Reference: http://tools.ietf.org/html/draft-hixie-thewebsocketprotocol

require "socket"
require "uri"
require "digest/md5"
require "openssl"


class WebSocket

    class << self

        attr_accessor(:debug)

    end

    class Error < RuntimeError

    end

    def initialize(arg, params = {})

        uri = arg.is_a?(String) ? URI.parse(arg) : arg

        if uri.scheme == "ws"
          default_port = 80
        elsif uri.scheme = "wss"
          default_port = 443
        else
          raise(WebSocket::Error, "unsupported scheme: #{uri.scheme}")
        end

        @path = (uri.path.empty? ? "/" : uri.path) + (uri.query ? "?" + uri.query : "")
        host = uri.host + (uri.port == default_port ? "" : ":#{uri.port}")
        origin = params[:origin] || "http://#{uri.host}"
        key1 = generate_key()
        key2 = generate_key()
        key3 = generate_key3()

        socket = TCPSocket.new(uri.host, uri.port || default_port)

        if uri.scheme == "ws"
          @socket = socket
        else
          @socket = ssl_handshake(socket)
        end

        write(
          "GET #{@path} HTTP/1.1\r\n" +
          "Upgrade: WebSocket\r\n" +
          "Connection: Upgrade\r\n" +
          "Host: #{host}\r\n" +
          "Origin: #{origin}\r\n" +
          "Sec-WebSocket-Key1: #{key1}\r\n" +
          "Sec-WebSocket-Key2: #{key2}\r\n" +
          "\r\n" +
          "#{key3}")
        flush()

        line = gets().chomp()
        raise(WebSocket::Error, "bad response: #{line}") if !(line =~ /\AHTTP\/1.1 101 /n)
        read_header()
        if @header["Sec-WebSocket-Origin"] != origin
          raise(WebSocket::Error,
            "origin doesn't match: '#{@header["WebSocket-Origin"]}' != '#{origin}'")
        end
        reply_digest = read(16)
        expected_digest = security_digest(key1, key2, key3)
        if reply_digest != expected_digest
          raise(WebSocket::Error,
            "security digest doesn't match: %p != %p" % [reply_digest, expected_digest])
        end
        @handshaked = true

      @closing_started = false
    end

    attr_reader(:header, :path)

    def send(data)
      if !@handshaked
        raise(WebSocket::Error, "call WebSocket\#handshake first")
      end
      data = force_encoding(data.dup(), "ASCII-8BIT")
      write("\x00#{data}\xff")
      flush()
    end

    def receive()
      if !@handshaked
        raise(WebSocket::Error, "call WebSocket\#handshake first")
      end
      packet = gets("\xff")
      return nil if !packet
      if packet =~ /\A\x00(.*)\xff\z/nm
        return force_encoding($1, "UTF-8")
      elsif packet == "\xff" && read(1) == "\x00" # closing
        if @server
          @socket.close()
        else
          close()
        end
        return nil
      else
        raise(WebSocket::Error, "input must be either '\\x00...\\xff' or '\\xff\\x00'")
      end
    end

    def tcp_socket
      return @socket
    end

    def host
      return @header["Host"]
    end

    def origin
      return @header["Origin"]
    end

    # Does closing handshake.
    def close()
      return if @closing_started
      write("\xff\x00")
      @socket.close() if !@server
      @closing_started = true
    end

    def close_socket()
      @socket.close()
    end

  private

    NOISE_CHARS = ("\x21".."\x2f").to_a() + ("\x3a".."\x7e").to_a()

    def read_header()
      @header = {}
      while line = gets()
        line = line.chomp()
        break if line.empty?
        if !(line =~ /\A(\S+): (.*)\z/n)
          raise(WebSocket::Error, "invalid request: #{line}")
        end
        @header[$1] = $2
      end
      if @header["Upgrade"] != "WebSocket"
        raise(WebSocket::Error, "invalid Upgrade: " + @header["Upgrade"])
      end
      if @header["Connection"] != "Upgrade"
        raise(WebSocket::Error, "invalid Connection: " + @header["Connection"])
      end
    end

    def gets(rs = $/)
      line = @socket.gets(rs)
      $stderr.printf("recv> %p\n", line) if WebSocket.debug
      return line
    end

    def read(num_bytes)
      str = @socket.read(num_bytes)
      $stderr.printf("recv> %p\n", str) if WebSocket.debug
      return str
    end

    def write(data)
      if WebSocket.debug
        data.scan(/\G(.*?(\n|\z))/n) do
          $stderr.printf("send> %p\n", $&) if !$&.empty?
        end
      end
      @socket.write(data)
    end

    def flush()
      @socket.flush()
    end

    def security_digest(key1, key2, key3)
      bytes1 = websocket_key_to_bytes(key1)
      bytes2 = websocket_key_to_bytes(key2)
      return Digest::MD5.digest(bytes1 + bytes2 + key3)
    end

    def generate_key()
      spaces = 1 + rand(12)
      max = 0xffffffff / spaces
      number = rand(max + 1)
      key = (number * spaces).to_s()
      (1 + rand(12)).times() do
        char = NOISE_CHARS[rand(NOISE_CHARS.size)]
        pos = rand(key.size + 1)
        key[pos...pos] = char
      end
      spaces.times() do
        pos = 1 + rand(key.size - 1)
        key[pos...pos] = " "
      end
      return key
    end

    def generate_key3()
      return [rand(0x100000000)].pack("N") + [rand(0x100000000)].pack("N")
    end

    def websocket_key_to_bytes(key)
      num = key.gsub(/[^\d]/n, "").to_i() / key.scan(/ /).size
      return [num].pack("N")
    end

    def force_encoding(str, encoding)
      if str.respond_to?(:force_encoding)
        return str.force_encoding(encoding)
      else
        return str
      end
    end

    def ssl_handshake(socket)
      ssl_context = OpenSSL::SSL::SSLContext.new()
      ssl_socket = OpenSSL::SSL::SSLSocket.new(socket, ssl_context)
      ssl_socket.sync_close = true
      ssl_socket.connect()
      return ssl_socket
    end

end