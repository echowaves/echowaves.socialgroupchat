class Convo
  include Mongoid::Document
  include Mongoid::Timestamps

  validates_presence_of :title
  validates_presence_of :user
  validates_length_of :title, :maximum => 140

  field :title, :type   => String
  field :privacy, :type => String

  embeds_one :user #yes, yes, yes! We are embedding user here, faster, and if the user ever gets deleted, the data will not be corrupted
  references_many :messages
  references_many :subscriptions
  references_many :invitations

  after_create :subscribe_owner

  def users
    self.subscriptions.map(&:user)
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
                Subscription.where(:user_id => user.id, :convo_id => self.id).first ||
                self.invitations.where(:user_id => user.id).first)
  end

  # just the owner for now
  def manageable_by_user?(user)
    user == self.user
  end

  def subscribe(user)
    if self.accesible_by_user?(user)
      Subscription.create(:user => user, :convo => self) unless self.users.include? user
      invitation = self.invitations.where(:user_id => user.id).first
      invitation.destroy if invitation.present?
    end
  end

  def unsubscribe(user)
    subscription = Subscription.where(:user_id => user.id, :convo_id => self.id).first
    subscription.destroy unless subscription.blank?
  end

  def invite_user(user)
    unless self.invitations.where(:user_id => user.id).first
      Invitation.create(:user => user, :convo => self, :requestor_id => self.user.id)
    end
  end

  def subscribe_owner
    Subscription.create(:user => user, :convo => self, :created_at => created_at) #should enforce the created_at the same as for conversation
  end
end
