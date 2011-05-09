# == Schema Information
# Schema version: 20110507000853
#
# Table name: followerships
#
#  id          :integer         not null, primary key
#  leader_id   :integer         not null
#  follower_id :integer         not null
#  created_at  :datetime
#  updated_at  :datetime
#

class Followership < ActiveRecord::Base
  # validations
  #----------------------------------------------------------------------  
  validates_presence_of :leader_id  
  validates_presence_of :follower_id
  validates_uniqueness_of :leader_id, :scope => :follower_id
  
  # associations
  #----------------------------------------------------------------------
  belongs_to :leader,   :class_name => "User"
  belongs_to :follower, :class_name => "User"
  
end
