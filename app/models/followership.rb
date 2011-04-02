class Followership
  include Mongoid::Document
  include Mongoid::Timestamps
  # the user_id is stored on this object, which defines the paren leader object who is being followed
  referenced_in :user
  # embedded user object is a follower
  embeds_one :follower, :class_name=>"User"
end
