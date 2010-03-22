# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Echowaves::Application.initialize!


config.frameworks -= [ :active_record ] # this line is usually commented out, uncomment it and change
