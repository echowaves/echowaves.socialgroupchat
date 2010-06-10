class Convo
  include Mongoid::Document
  validates_presence_of :title
  validates_length_of :title, :maximum => 140
  
  
  field :title, :type => String
  embeds_one :user
end
