class Message < ActiveRecord::Base

  validates_presence_of :owner

  belongs_to :owner, class_name: "User"  
  belongs_to :convo

  # field :uuid
  # field :body
end
