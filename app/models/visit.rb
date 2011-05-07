# == Schema Information
# Schema version: 20110507000853
#
# Table name: visits
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  convo_id   :integer
#  created_at :datetime
#  updated_at :datetime
#

class Visit < ActiveRecord::Base

  belongs_to :user
  belongs_to :convo  

end
