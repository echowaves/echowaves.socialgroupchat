# == Schema Information
# Schema version: 20110507000853
#
# Table name: subscriptions
#
#  id                   :integer         not null, primary key
#  user_id              :integer
#  convo_id             :integer
#  last_read_message_id :integer
#  new_messages_count   :integer
#  created_at           :datetime
#  updated_at           :datetime
#

class Subscription < ActiveRecord::Base
    
  validates_presence_of :convo
  validates_presence_of :user

  belongs_to :convo
  belongs_to :user
      
end
