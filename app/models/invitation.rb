class Invitation
  include Mongoid::Document
  include Mongoid::Timestamps

  referenced_in :convo
  referenced_in :user

  field :requestor_id, :type => String # t.integer
  field :token, :type => String

  before_create :generate_token

  def generate_token
    self.token = UUID.create.to_s
  end

end
