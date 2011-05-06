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
  gem 'capybara', "~> 0.4.1.2"
  gem 'rspec', ">=2.5.0"
  gem 'rspec-rails', "~> 2.5.0"
  # gem "remarkable_rails" # does not work yet
  gem "remarkable_activerecord"
  gem 'steak', '~> 1.1.0'
  gem "miniskirt"
  gem 'launchy', ">=0.4.0"
  gem 'simplecov', ">=0.4.2", :require => false  
  gem 'ruby-graphviz'
  # autotest stuff
  gem 'autotest'
  gem 'ZenTest'
  gem 'autotest-rails'
  gem 'autotest-growl'
end
