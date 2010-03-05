# Edit this Gemfile to bundle your application's dependencies.
source 'http://gemcutter.org'


## Bundle edge rails:
gem "rails", :git => "git://github.com/rails/rails.git"

## Bundle the gems you use:

# cuke and friends for rails 3
gem 'capybara',         :git => 'git://github.com/jnicklas/capybara.git'
gem 'database_cleaner', :git => 'git://github.com/bmabey/database_cleaner.git'
gem 'cucumber-rails',   :git => 'git://github.com/aslakhellesoy/cucumber-rails.git'

gem 'mongoid', :git => 'git://github.com/durran/mongoid.git', :branch => 'prerelease'
# gem 'devise',  :git => 'git://github.com/plataformatec/devise.git'
# gem "warden"
gem "mongo_ext"

## Bundle gems used only in certain environments:
group :test do
  gem "rspec-rails", ">= 2.0.0.beta.2"
end
