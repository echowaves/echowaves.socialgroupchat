class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Gravatarify::Helper

  # Include default devise modules. Others available are:
  # :http_authenticatable, :token_authenticatable, :lockable, :timeoutable and :activatable
  devise :database_authenticatable, :registerable, :confirmable, :recoverable, 
  :rememberable, :trackable, :validatable, :encryptable, :encryptor => 'sha1'
  
  validates_presence_of :username
  validates_uniqueness_of :username

  has_many :subscriptions
  has_many :invitations
  
    # user will have many followerships, each will embedd a follower user, the user_id is stored on the followership object
  has_many :followerships
  
  has_many :convos
  has_many :messages
  
  embeds_many :visits

  field :username, :unique => true, :background => true #  t.string,  :null               => false
  field :email, :unique => true, :background => true #  t.string,  :null               => false
  field :encrypted_password # t.string, :limit   => 40, :null => false
  field :password_salt # t.string, :null         => false
  field :confirmation_token # t.string, :limit   => 20
  field :confirmed_at, :type => DateTime # t.datetime
  field :confirmation_sent_at, :type => DateTime # t.datetime
  field :reset_password_token # t.string, :limit => 20
  field :remember_token # t.string, :limit       => 20
  field :remember_created_at, :type => DateTime # t.datetime
  field :sign_in_count, :type => Integer # t.integer
  field :current_sign_in_at, :type => DateTime # t.datetime
  field :last_sign_in_at, :type => DateTime # t.datetime
  field :current_sign_in_ip # t.string
  field :last_sign_in_ip # t.string
  field :failed_attempts, :type => Integer, :default => 0 # t.integer, :default   => 0
  field :unlock_token # t.string, :limit         => 20
  field :locked_at, :type => DateTime # t.datetime

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
        p "#{subscription.id} last_read_message_id saved::::::::::::: #{subscription.last_read_message_id}"
      end
      subscription.save      
    end
  end
  
  def visited_convos
  # TODO n+1 query here!!!!!!!!!!!!!!!!!!!!!!
    self.visits.map(&:convo).reverse
  end

  
  # returns an array of subscription that have updates (new messages), since last visit
  def updates
    # now update the subscriptions if there are any news
    # TODO: let's not worry about premature optimization, but the following code will be sloooooow for now
    updated_subscriptions = []
    # lets check each subscription, update it if there are new messages, and add it to the @updated_subscriptions
    self.subscriptions.each do |s| 
      messages = s.convo.messages.asc(:created_at)
      unless messages.count == 0 # no messages -- no updates
        p "#{s.id} last_read_message_id read::::::::::::#{s.last_read_message_id}"
        # just started posting new messages to a new convo which was never visited before
        if s.last_read_message_id == nil
          s.new_messages_count = messages.count         # s.last_read_message_id = messages.first.id
          s.save
        else
          last_message = messages.last
          p '??????????????????????'
          p s.last_read_message_id
          p s.new_messages_count
          p last_message.id 
          p messages.first.id 
          p messages.count

          if s.last_read_message_id != last_message.id 
            # some new updates, let's update the count
            s.new_messages_count = messages.count(:created_at.gte => last_read_message.created_at)
            s.save
            updated_subscriptions << s
            
          end        
        end #  if s.last_read_message_id == nil
      end # unless messages.count == 0
    end # @subscriptions.each
    p "#####################################"
    p "returning updated subscriptions"
    p updated_subscriptions
    updated_subscriptions 
  end
  
end
