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
  references_many :convo_users

  after_create :subscribe_owner

  def users
    self.convo_users.map(&:user)
  end

  def public?
    self.privacy == "public"
  end

  def private?
    !public?
  end

  def accesible_by_user?(user)
    self.public? ||
      user && ( user == self.user ||
                ConvoUser.where(:user_id => user.id, :convo_id => self.id).first )
  end

  def add_user(user)
    if self.accesible_by_user?(user)
      ConvoUser.create(:user => user, :convo => self) unless self.users.include? user
    end
  end

  def remove_user(user)
    subscription = ConvoUser.where(:user_id => user.id, :convo_id => self.id).first
    subscription.destroy unless subscription.blank?
  end

  def subscribe_owner
    add_user self.user
  end
end
