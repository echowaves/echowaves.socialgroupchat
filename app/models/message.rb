class Message
  include Mongoid::Document
  include Mongoid::Timestamps

  embeds_one :user

  referenced_in :convo

  field :uuid
  field :body
end
