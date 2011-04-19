class Invitation
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :convo
  belongs_to :user

  belongs_to :requestor, class_name: "User"

  validates_presence_of :convo
  validates_presence_of :user
  validates_presence_of :requestor

  
end
