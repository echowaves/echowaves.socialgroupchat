require 'gravatarify'

# include view helpers only if ActionView is available
ActionView::Base.send(:include, Gravatarify::Helper) if defined?(ActionView)
