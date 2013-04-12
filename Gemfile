# Edit this Gemfile to bundle your application's dependencies.

source 'http://rubygems.org'

gem 'rails', '3.2.13'
# Asset template engines  
gem 'sass'  
gem 'coffee-script'  
gem 'uglifier'  
  
gem 'jquery-rails'

gem 'unicorn'

gem "socky-server", "~> 0.5.0" # this is a stand-alone server, is not part of the app and should not be here
gem "socky-client-rails", "~> 0.4.5" # this is the client used to connect the app to the server

# gem "postgres-pr"
gem "pg"

# gem "devise", "~>1.3.4"
gem "devise", '1.4.7'
gem "kaminari" #replacement for willpaginate

gem 'gravatarify', "~> 3.1.0"
# gem 'escape_utils' # this will fix an issue with Rack::Test 1.2.1 and ruby 1.9.2
gem 'dynamic_form'

group :test, :development do
  gem 'capybara', '2.1.0'
  # gem 'steak'
  gem "database_cleaner"
  gem 'rspec', '2.13.0'
  gem 'rspec-rails', '2.13.0'
  gem 'shoulda-matchers', '2.0.0'
  # gem "annotate-models", :require => false
  gem "miniskirt"
  gem 'launchy'
  gem 'simplecov', :require => false
  gem 'ruby-graphviz'
  # gem 'spork', '~> 0.9.0.rc'
  # guard stuff
  gem 'rb-fsevent', :require => false if RUBY_PLATFORM =~ /darwin/i
  gem 'guard-rspec'
  # gem "guard-livereload", "~> 0.1.11" #has conflict, removing for now
  gem 'growl_notify'
  gem 'hirb'
#  gem 'bullet' # for finding n+1
end
