# == Schema Information
# Schema version: 20110507000853
#
# Table name: messages
#
#  id         :integer         not null, primary key
#  uuid       :string(255)     not null
#  body       :string(255)     not null
#  owner_id   :integer         not null
#  created_at :datetime
#  updated_at :datetime
#

class Message < ActiveRecord::Base

  validates_presence_of :owner

  belongs_to :owner, class_name: "User"
  belongs_to :convo

end
