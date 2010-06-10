class Convo
  include Mongoid::Document
  field :title, :type => String
  embeds_one :user
end
