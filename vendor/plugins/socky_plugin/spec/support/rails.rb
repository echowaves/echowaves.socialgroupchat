unless defined?(Rails)
  require 'pathname'
  require 'rails/version'
  module Rails
    def self.root
      Pathname.new(File.dirname(__FILE__))
    end
  end
end