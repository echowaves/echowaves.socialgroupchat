# Edit this Gemfile to bundle your application's dependencies.

source 'http://gemcutter.org'

gem "rails", "3.0.3"

gem "socky-server" # this is a stand-alone server, is not part of the app and should not be here
gem "socky-client-rails" # this is the client used to connect the app to the server

gem "mongoid", "2.0.0.beta.20"
gem "bson_ext", "1.1.4"
gem "devise", "1.1.5"
gem "will_paginate", "~> 3.0.pre2"
gem "gravatarify", ">= 2.2.2"
gem "escape_utils" # this will fix an issue with Rack::Test 1.2.1 and ruby 1.9.2

group :test do
  gem 'cucumber'
  gem 'capybara'
  # gem 'database_cleaner'
  gem 'cucumber-rails'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'spork'
  gem 'launchy'
  gem 'machinist_mongo'
  gem 'faker'
  gem 'cucover'
end
