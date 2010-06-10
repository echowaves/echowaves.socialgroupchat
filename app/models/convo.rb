class Convo
  include Mongoid::Document
  field :title
  embeds_one :user
end
