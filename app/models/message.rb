# == Schema Information
# Schema version: 20110507000853
#
# Table name: messages
#
#  id         :integer         not null, primary key
#  uuid       :string(255)     not null
#  body       :string(256000)  not null
#  owner_id   :integer         not null
#  convo_id   :integer         not null
#  created_at :datetime
#  updated_at :datetime
#

class Message < ActiveRecord::Base

  # validations
  #----------------------------------------------------------------------  
  
  validates_presence_of :uuid
  validates_presence_of :body
  validates_presence_of :owner
  validates_presence_of :convo
  validates_length_of :uuid, :maximum => 255
  validates_length_of :body, :maximum => 256000

  # associations
  #----------------------------------------------------------------------
  belongs_to :owner, class_name: "User"
  belongs_to :convo
  #----------------------------------------------------------------------
 
end
