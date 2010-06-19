class Convo
  include Mongoid::Document
  validates_presence_of :title
  validates_length_of :title, :maximum => 140
  validates_presence_of :user

  field :title, :type => String
  embed_one :user #yes, yes, yes! We are embedding user here, faster, and if the user ever gets deleted, the data will not be corrupted
end
