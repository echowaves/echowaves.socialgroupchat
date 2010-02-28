@settings = {
  "development" => {:host => 'localhost', :database => 'echowaves_development'},
  "production" => {:host => 'localhost', :database => 'echowaves_production'},
  "test" => {:host => 'localhost', :database => 'echowaves_test'}
}

Mongoid.configure do |config|
  name = @settings[Rails.env][:database]
  host = @settings[Rails.env][:host]
  config.master = Mongo::Connection.new.db(name)
  #config.slaves = [
  #  Mongo::Connection.new(host, @settings["slave_one"]["port"], :slave_ok => true).db(name),
  #  Mongo::Connection.new(host, @settings["slave_two"]["port"], :slave_ok => true).db(name)
  #]
end
