# Edit this Gemfile to bundle your application's dependencies.

source 'http://gemcutter.org'

gem "rails", "3.0.5"

gem 'unicorn'

gem "socky-server", ">= 0.4.0" # this is a stand-alone server, is not part of the app and should not be here
gem "socky-client-rails", ">= 0.4.3" # this is the client used to connect the app to the server

gem "mongoid", "~> 2.0.0"
# gem "mongoid", :git => "git://github.com/mongoid/mongoid.git", :branch => "safe_master"

gem "bson_ext", "~> 1.2.0"
gem "devise", "~> 1.2.rc"
gem "will_paginate", "~> 3.0.pre2"
gem 'gravatarify', "~> 2.2.2"
gem 'escape_utils' # this will fix an issue with Rack::Test 1.2.1 and ruby 1.9.2
gem 'dynamic_form'

group :test, :development do
  gem 'capybara', "~> 0.4.1.2"
  gem 'rspec', ">=2.5.0"
  gem 'rspec-rails', "~> 2.5.0"
  gem 'mongoid-rspec', :git => 'https://github.com/shingara/mongoid-rspec.git', :branch => 'mongoid-2.0.0.rc1'
  gem 'steak', '~> 1.1.0'
  # gem 'spork', "~> 0.9.0.rc2"
  gem 'launchy', ">=0.4.0"
  # gem 'machinist_mongo', "~> 2.0.0.pre"
  gem 'machinist_mongo', :require => 'machinist/mongoid', :git => "git://github.com/nmerouze/machinist_mongo.git", :branch => 'machinist2'
   # or mongo_mapper
  # gem 'faker', ">=0.9.5"
  gem 'simplecov', :require => false  
  gem 'ruby-graphviz'
  # autotest stuff
  gem 'autotest'
  gem 'ZenTest'
  gem 'autotest-rails'
  gem 'autotest-growl'
end
