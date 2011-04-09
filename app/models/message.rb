class Message
  include Mongoid::Document
  include Mongoid::Timestamps

  embeds_one :user

  belongs_to :convo

  field :uuid
  field :body
end
