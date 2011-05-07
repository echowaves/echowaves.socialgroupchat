# == Schema Information
# Schema version: 20110507000853
#
# Table name: invitations
#
#  id           :integer         not null, primary key
#  user_id      :integer
#  convo_id     :integer
#  requestor_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class Invitation < ActiveRecord::Base

  belongs_to :convo
  belongs_to :user

  belongs_to :requestor, class_name: "User"

  validates_presence_of :convo
  validates_presence_of :user
  validates_presence_of :requestor

  
end
