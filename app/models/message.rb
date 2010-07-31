class Message
  include Mongoid::Document
  include Mongoid::Timestamps

  field :body
end
