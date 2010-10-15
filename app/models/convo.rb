class Convo
  include Mongoid::Document
  include Mongoid::Timestamps

  validates_presence_of :title
  validates_length_of :title, :maximum => 140
  validates_presence_of :user

  field :title, :type   => String
  field :privacy, :type => String

  embed_one :user #yes, yes, yes! We are embedding user here, faster, and if the user ever gets deleted, the data will not be corrupted
  references_many :messages

  def public?
    self.privacy == "public"
  end

  def private?
    !public?
  end

  def accesible_by_user?(user)
    self.public? ||
      user == self.user ||
      ConvoUser.where(:user_id => user.id, :convo_id => self.id).first
  end
end
