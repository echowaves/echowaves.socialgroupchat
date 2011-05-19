# == Schema Information
# Schema version: 20110507000853
#
# Table name: subscriptions
#
#  id                   :integer         not null, primary key
#  user_id              :integer         not null
#  convo_id             :integer         not null
#  last_read_message_id :integer         default(0), not null
#  new_messages_count   :integer         default(0), not null
#  created_at           :datetime
#  updated_at           :datetime
#

class Subscription < ActiveRecord::Base
    
  # validations
  #----------------------------------------------------------------------  
  validates_presence_of :convo
  validates_presence_of :user
  validates_uniqueness_of :user_id, :scope => :convo_id
  
  # associations
  #----------------------------------------------------------------------
  belongs_to :convo, :counter_cache => true
  belongs_to :user,  :counter_cache => true
  #----------------------------------------------------------------------
      
  default_scope includes(:user, :convo)
end
