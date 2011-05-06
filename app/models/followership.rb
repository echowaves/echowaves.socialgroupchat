class Followership < ActiveRecord::Base
  # the user_id is stored on this object, which defines the paren leader object who is being followed
  belongs_to :user
  
  # field :follower_id 

  validates_presence_of :user_id  
  validates_presence_of :follower_id
  
  # egh, n+1, eventually should probably just embed needed fields, rather then id only
  def follower
    User.find(self.follower_id)
  end
  
end
