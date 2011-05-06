class Subscription < ActiveRecord::Base
    
  validates_presence_of :convo
  validates_presence_of :user

  belongs_to :convo
  belongs_to :user
  
  # field :last_read_message_id
  # field :new_messages_count, type: Integer
    
end
