# == Schema Information
# Schema version: 20110507000853
#
# Table name: followerships
#
#  id          :integer         not null, primary key
#  leader_id   :integer
#  follower_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Followership < ActiveRecord::Base
  # the user_id is stored on this object, which defines the paren leader object who is being followed
  belongs_to :leader,   :class_name => "User"
  belongs_to :follower, :class_name => "User"
  
  validates_presence_of :leader_id  
  validates_presence_of :follower_id

  validates_uniqueness_of :leader_id, :scope => :follower_id
    
end
