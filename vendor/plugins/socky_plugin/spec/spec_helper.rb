require 'rubygems'
require 'spec'
require "spec/autorun"

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}
require 'lib/socky'