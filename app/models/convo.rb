# == Schema Information
# Schema version: 20110507000853
#
# Table name: convos
#
#  id            :integer         not null, primary key
#  title         :string(140)     not null
#  privacy_level :integer         default(0), not null
#  owner_id      :integer         not null
#  created_at    :datetime
#  updated_at    :datetime
#

class Convo < ActiveRecord::Base
 
  # validations
  #----------------------------------------------------------------------  
  validates_presence_of :title
  validates_presence_of :owner
  validates_presence_of :privacy_level
  validates_length_of :title, :maximum => 140

  # associations
  #----------------------------------------------------------------------
  #the owner of the convo
  belongs_to :owner, class_name: "User"
  
  has_many :messages
  has_many :subscriptions
  has_many :invitations
  
  has_many :visits
  has_many :visiting_users, through: :visits, source: :user
  #----------------------------------------------------------------------
  
  after_create :subscribe_owner

  def users
    self.subscriptions.map(&:user)
  end

  def public?
    self.privacy_level == 1
  end

  def private?
    !public?
  end

  def accesible_by_user?(user)
    # p "#{self.public?} || #{user} && ( #{user} == #{self.owner} || #{self.subscriptions.exists?(:user_id => user.id)} || #{self.invitations.exists?(:user_id => user.id)})"
    self.public? ||
      user && ( user == self.owner ||
                self.subscriptions.exists?(:user_id => user.id) ||
                self.invitations.exists?(:user_id => user.id))
  end

  # just the owner for now
  def manageable_by_user?(user)
    user == self.owner
  end

  def subscribe(user)
    if self.accesible_by_user?(user)
      self.subscriptions.create(user: user) unless self.subscriptions.exists?(user_id: user.id)
      self.invitations.where(:user_id => user.id).destroy_all
    end
  end

  def unsubscribe(user)
    subscription = self.subscriptions.where(:user_id => user.id)
    subscription.destroy_all
  end

  def invite_user(user, requestor)
    if accesible_by_user? requestor
      unless self.invitations.where(:user_id => user.id).first
        Invitation.create(:user => user, :convo => self, :requestor => requestor)
      end
    end
  end

  def subscribe_owner
    Subscription.create(:user => owner, :convo => self, :created_at => created_at) #should enforce the created_at the same as for conversation
  end
end
