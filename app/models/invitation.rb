class Invitation
  include Mongoid::Document
  include Mongoid::Timestamps

  referenced_in :convo
  referenced_in :user

  field :requestor_id, :type => String # t.integer
end
