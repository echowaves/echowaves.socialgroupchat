# this model represents a many-to-many relationship between convos and users, it should store the embedded objects for performance, the current mongoid supports many to many implementation through embedded arrays of object id's but then we would loose the Timestamps -- need to use the intermidiate model
class Subscription
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :convo
  belongs_to :user  
end
