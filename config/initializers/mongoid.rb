File.open(File.join(RAILS_ROOT, 'config/database.mongo.yml'), 'r') do |f|
  @settings = YAML.load(f)[RAILS_ENV]
end

Mongoid.configure do |config|
  name = @settings["database"]
  host = @settings["host"]
  config.master = Mongo::Connection.new.db(name)
  #config.slaves = [
  #  Mongo::Connection.new(host, @settings["slave_one"]["port"], :slave_ok => true).db(name),
  #  Mongo::Connection.new(host, @settings["slave_two"]["port"], :slave_ok => true).db(name)
  #]
end
