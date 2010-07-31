# this model represents a many-to-many relationship between convos and users, it stores the embedded objects for performance
class ConvoUser
  include Mongoid::Document
  include Mongoid::Timestamps

  validates_presence_of :convo
  validates_presence_of :user

  referenced_in :convo
  referenced_in :user
end
