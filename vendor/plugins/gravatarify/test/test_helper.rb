require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'rr'
require 'gravatarify'

Test::Unit::TestCase.send :include, RR::Adapters::TestUnit

# Reset +Gravatarify+ to default hosts and cleared options
def reset_gravatarify!
  Gravatarify.options.clear
  Gravatarify.options[:filetype] = :jpg
  Gravatarify.subdomains = %w{ 0 1 2 www }  
end

# some often used values...
BELLA_AT_GMAIL = "http://www.gravatar.com/avatar/1cacf1bc403efca2e7a58bcfa9574e4d"
BELLA_AT_GMAIL_JPG = "#{BELLA_AT_GMAIL}.jpg"
NIL_JPG = "http://www.gravatar.com/avatar/d41d8cd98f00b204e9800998ecf8427e.jpg"
