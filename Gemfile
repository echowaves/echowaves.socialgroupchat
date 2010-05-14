# Edit this Gemfile to bundle your application's dependencies.
source 'http://gemcutter.org'


## Bundle edge rails:
gem "rails", :git => "git://github.com/rails/rails.git"
#gem "rails", "3.0.0.beta3"

## Bundle the gems you use:

# cuke and friends for rails 3
gem 'capybara',         :git => 'git://github.com/jnicklas/capybara.git'
gem 'database_cleaner', :git => 'git://github.com/bmabey/database_cleaner.git'
gem 'cucumber-rails',   :git => 'git://github.com/aslakhellesoy/cucumber-rails.git'
gem 'test-unit'
gem 'mongoid', :git => 'git://github.com/durran/mongoid.git', :branch => 'prerelease'
gem "bson_ext"
gem "devise", :git => 'git://github.com/railsjedi/devise.git' # "mongoid compatible"
gem "warden", "0.10.3"


## Bundle gems used only in certain environments:
group :test do
  gem "rspec-rails", ">= 2.0.0.beta.8"
end
