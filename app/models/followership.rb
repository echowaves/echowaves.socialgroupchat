# == Schema Information
# Schema version: 20110507000853
#
# Table name: followerships
#
#  id          :integer         not null, primary key
#  user_id     :integer
#  follower_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Followership < ActiveRecord::Base
  # the user_id is stored on this object, which defines the paren leader object who is being followed
  belongs_to :user
  belongs_to :follower, :class_name => "User"
  
  validates_presence_of :user_id  
  validates_presence_of :follower_id
    
end
