# == Schema Information
# Schema version: 20110507000853
#
# Table name: visits
#
#  id           :integer         not null, primary key
#  user_id      :integer         not null
#  convo_id     :integer         not null
#  visits_count :integer         default(0), not null
#  created_at   :datetime
#  updated_at   :datetime
#


class Visit < ActiveRecord::Base
  # validations
  #----------------------------------------------------------------------  
  validates_presence_of :user_id
  validates_presence_of :convo_id
  validates_presence_of :visits_count
  validates_uniqueness_of :user_id, :scope => :convo_id

  # associations
  #----------------------------------------------------------------------
  belongs_to :user
  belongs_to :convo  

end
