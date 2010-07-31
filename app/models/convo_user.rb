# this model represents a many-to-many relationship between convos and users, it stores the embedded objects for performance
class ConvoUser
  include Mongoid::Document
  validates_presence_of :convo
  validates_presence_of :user

  embed_one :convo
  embed_one :user
end
