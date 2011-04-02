# this model represents a many-to-many relationship between convos and users, it should store the embedded objects for performance
class Subscription
  include Mongoid::Document
  include Mongoid::Timestamps

  referenced_in :convo
  referenced_in :user  
end
