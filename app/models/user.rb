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
#  created_at           :datetime
#  updated_at           :datetime
#

class User  < ActiveRecord::Base
  include Gravatarify::Helper

  # Include default devise modules. Others available are:
  # :http_authenticatable, :token_authenticatable, :lockable, :timeoutable and :activatable
  devise :database_authenticatable, :registerable, :confirmable, :recoverable, 
  :rememberable, :trackable, :validatable, :encryptable, :encryptor => 'sha1'
  
  validates_presence_of :username
  validates_uniqueness_of :username

  has_many :subscriptions
  has_many :invitations
  

  has_many :followerships
  has_many :convos,   :foreign_key => "owner_id"
  has_many :messages, :foreign_key => "owner_id"
  
  has_many :visits

  attr_accessible :username, :email, :password, :password_confirmation

  def gravatar
    gravatar_url email
  end

  def follow(user)
      Followership.create(:user_id=>user.id, :follower_id=>self.id) unless self.follows?(user)
  end

  def unfollow(user)
    followerships = Followership.where(:user_id=>user.id, :follower_id=>self.id)
    followerships.destroy unless followerships.blank?
  end
  
  def follows?(user)
    Followership.where(:user_id=>user.id, :follower_id=>self.id).count > 0 ? true : false
  end
  
  def followed?(user)
    user.follows?(self)
  end

  def visit convo
    # delete a visit to this convo if already exists
    visits.where(:convo_id => convo.id).destroy if visits.size > 0
    # append as a last element of the embedded collection
    visits<<Visit.new(convo_id: convo.id)
    # destroy the first visit if collection grows bigger then 100
    visits[0].destroy if visits.count > 100

    # update subscription visits count
    subscription = self.subscriptions.where(convo_id: convo.id)[0]
    if subscription != nil
      subscription.new_messages_count = 0 # reset the new messages count while visiting
      if convo.messages.count != 0
        subscription.last_read_message_id = convo.messages.asc(:created_at).last.id
      end
      subscription.save      
    end
  end
  
  def visited_convos
  # TODO n+1 query here!!!!!!!!!!!!!!!!!!!!!!
    self.visits.map(&:convo).reverse
  end

  
  # returns an array of subscription that have updates (new messages), since last visit
  def updated_subscriptions
    # now update the subscriptions if there are any news
    # TODO: let's not worry about premature optimization, but the following code will be sloooooow for now
    updated_subscriptions = []
    # lets check each subscription, update it if there are new messages, and add it to the @updated_subscriptions
    self.subscriptions.each do |s| 
      my_messages = s.convo.messages.asc(:created_at) # calling my_messages to avoid naming collision
      unless my_messages.count == 0 # no messages -- no updates
        # just started posting new messages to a new convo which was never visited before
        if s.last_read_message_id == nil
          s.new_messages_count = my_messages.count         # s.last_read_message_id = messages.first.id
          s.save
          updated_subscriptions << s
        else
          last_message = my_messages.last
          if s.last_read_message_id != last_message.id 
            # some new updates, let's update the count
            last_read_message = my_messages.find(s.last_read_message_id)
            s.new_messages_count = my_messages.where(:created_at.gt => last_read_message.created_at).count
            s.save
            updated_subscriptions << s
          end        
        end #  if s.last_read_message_id == nil
      end # unless messages.count == 0
    end # @subscriptions.each
    updated_subscriptions 
  end
  
end
