class Invitation
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :convo
  belongs_to :user

  field :requestor_id, :type => String # t.integer
end
