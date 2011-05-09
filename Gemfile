# Edit this Gemfile to bundle your application's dependencies.

source 'http://gemcutter.org'

gem "rails", "3.0.7"

gem 'unicorn'

gem "socky-server", ">= 0.4.0" # this is a stand-alone server, is not part of the app and should not be here
gem "socky-client-rails", ">= 0.4.3" # this is the client used to connect the app to the server

# gem "postgres-pr"
gem "pg"

gem "devise", "~>1.3.4"
gem "kaminari" #replacement for willpaginate

gem 'gravatarify', "~> 2.2.2"
# gem 'escape_utils' # this will fix an issue with Rack::Test 1.2.1 and ruby 1.9.2
gem 'dynamic_form'

group :test, :development do
  gem 'capybara'
  gem 'rspec'
  gem 'rspec-rails'
  gem "annotate-models", :require => false
  # gem "remarkable_rails" # does not work yet
  gem "remarkable_activerecord", ">= 4.0.0.alpha4"
  gem 'steak'
  gem "miniskirt"
  gem 'launchy'
  gem 'simplecov', :require => false
  gem 'ruby-graphviz'
  gem 'spork', '~> 0.9.0.rc'
  # guard stuff
  gem 'rb-fsevent', :require => false if RUBY_PLATFORM =~ /darwin/i  
  gem 'guard-rspec'
  gem 'guard-livereload'
  gem 'growl'
end
