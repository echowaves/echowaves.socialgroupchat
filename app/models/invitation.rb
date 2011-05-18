# == Schema Information
# Schema version: 20110507000853
#
# Table name: invitations
#
#  id           :integer         not null, primary key
#  convo_id     :integer         not null
#  user_id      :integer         not null
#  requestor_id :integer         not null
#  created_at   :datetime
#  updated_at   :datetime
#

class Invitation < ActiveRecord::Base


  # validations
  #----------------------------------------------------------------------  
  validates_presence_of :user
  validates_presence_of :convo
  validates_presence_of :requestor
  validates_uniqueness_of :convo_id, :scope => :user_id

  # associations
  #----------------------------------------------------------------------
  belongs_to :user
  belongs_to :convo
  belongs_to :requestor, class_name: "User"
  #----------------------------------------------------------------------

  
end
