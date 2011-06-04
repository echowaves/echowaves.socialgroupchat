# == Schema Information
# Schema version: 20110507000853
#
# Table name: users
#
#  id                   :integer         not null, primary key
#  username             :string(128)
#  email                :string(255)     default(""), not null
#  encrypted_password   :string(128)     default(""), not null
#  confirmation_token   :string(255)
#  confirmed_at         :datetime
#  confirmation_sent_at :datetime
#  reset_password_token :string(255)
#  remember_token       :string(255)
#  remember_created_at  :datetime
#  sign_in_count        :integer         default(0)
#  current_sign_in_at   :datetime
#  last_sign_in_at      :datetime
#  current_sign_in_ip   :string(255)
#  last_sign_in_ip      :string(255)
#  password_salt        :string(255)
#  subscriptions_count  :integer         default(0)
#  created_at           :datetime
#  updated_at           :datetime
#

class User  < ActiveRecord::Base
  include Gravatarify::Helper

  # Include default devise modules. Others available are:
  # :http_authenticatable, :token_authenticatable, :lockable, :timeoutable and :activatable
  devise :database_authenticatable, :registerable, :confirmable, :recoverable,
  :rememberable, :trackable, :validatable, :encryptable, :encryptor => 'sha1'

  # validations
  #----------------------------------------------------------------------
  validates_presence_of   :username
  validates_uniqueness_of :username
  validates :email,   
            :presence => true,   
            :format => { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i }
            
  # associations
  #----------------------------------------------------------------------
  has_many :subscriptions
  has_many :subscribed_convos, :through => :subscriptions, :source => :convo

  has_many :invitations
  has_many :convo_invites, :through => :invitations, :source => :convo, limit: 100, :order => "invitations.created_at DESC"

  has_many :followerships, :foreign_key => "leader_id"
  has_many :followers, :through => :followerships

  has_many :leaderships, :foreign_key => "follower_id", :source => :followership, :class_name => "Followership"
  has_many :leaders,   :through => :leaderships

  has_many :visits, limit: 100, :order => "visits.updated_at DESC"
  has_many :visited_convos, :through => :visits, :source => :convo, limit: 100, :order => "visits.updated_at DESC"

  has_many :convos,   :foreign_key => "owner_id"
  has_many :messages, :foreign_key => "owner_id"
  #----------------------------------------------------------------------


  attr_accessible :username, :email, :password, :password_confirmation

  def gravatar
    gravatar_url email
  end

  def follow(leader)
    leader.followers << self
  end

  def unfollow(leader)
    leader.followers.delete(self)
  end

  def follows?(leader)
    leader.followerships.exists?(:follower_id => self.id)
  end

  def followed?(follower)
    self.followerships.exists?(:follower_id => follower.id)
  end

  def visit convo
    # append as a last element of the embedded collection
    if visit = visits.find_by_convo_id(convo.id)
      visit.increment!( :visits_count )
    else
      self.visits.create(convo: convo)
    end

    # update subscription visits count
    if self.subscriptions.exists?(convo_id: convo.id)
      subscription = self.subscriptions.where(convo_id: convo.id)[0]
      subscription.new_messages_count = 0 # reset the new messages count while visiting
      if convo.messages.count != 0
        subscription.last_read_message_id = convo.messages.last.id
      end
      subscription.save
    end
  end


  # FIXME: code smels badly
  # returns an array of subscription that have updates (new messages), since last visit
  def updated_subscriptions
    # the original way
    # @updated_subscriptions = self.subscriptions.reject { |subscription| subscription.new_messages_count == 0 }
    # the new way, slightly more efficient
    # @updated_subscriptions = self.subscriptions.find(:all,
    # :joins => "JOIN convos ON subscriptions.convo_id=convos.id JOIN messages ON convos.id = messages.convo_id and messages.id > subscriptions.last_read_message_id",
    # :group => "convos.id",
    # :order => "messages.id ASC",
    # :limit => 25)

    # we will implement bruit force for now
    @updated_subscriptions = self.subscriptions.map do |s|
      s.new_messages_count = s.convo.messages.count( :conditions => ["id >  #{s.last_read_message_id}" ] )
      s
    end

    @updated_subscriptions.reject! { |s| s.new_messages_count == 0 }
    @updated_subscriptions
  end

end
