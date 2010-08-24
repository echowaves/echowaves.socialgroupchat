# Loads all required submodules
module Gravatarify
  # current API version, as defined by http://semver.org/
  VERSION = "2.1.0".freeze
  
  autoload :Base,   'gravatarify/base'
  autoload :Utils,  'gravatarify/utils'
  autoload :Helper, 'gravatarify/helper'
end

# and add HAML support (if defined)
Haml::Helpers.send(:include, Gravatarify::Helper) if defined?(Haml)
