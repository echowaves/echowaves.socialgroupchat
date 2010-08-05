class Message
  include Mongoid::Document
  include Mongoid::Timestamps

  embed_one :user

  referenced_in :convo

  field :uuid
  field :body
end
