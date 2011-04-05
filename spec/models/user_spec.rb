require 'spec_helper'

describe User do
  describe "mongoid-rspec" do
    it { should have_fields(:created_at, :updated_at).of_type(Time) }

    it { should validate_presence_of :username }
    it { should validate_uniqueness_of :username }

    it { should reference_many :subscriptions }
    it { should reference_many :invitations }
    it { should reference_many :followerships }

    it { should validate_uniqueness_of( :username) }
    it { should validate_uniqueness_of( :email) }

    it { should have_fields(:username, :email, :encrypted_password, :password_salt, :confirmation_token) }
    it { should have_fields(:confirmed_at, :confirmation_sent_at, :remember_created_at, :current_sign_in_at, :last_sign_in_at, :locked_at).of_type(DateTime) }

    it { should have_fields( :reset_password_token, :remember_token, :current_sign_in_at, :last_sign_in_ip, :unlock_token) }

    it { should have_fields( :sign_in_count).of_type(Integer)}
    it { should have_fields( :failed_attempts).of_type(Integer).with_default_value_of(0)}
  end


  describe "business logic" do
    it "should produce gravatar url" do
      user = User.make(:email => "test@example.com")
      user.gravatar.should include("gravatar.com/avatar/55502f40dc8b7c769880b10874abc9d0.jpg")      
    end
  end


  describe "followers logic" do
    before do
      @follower = User.make!
      @leader = User.make!
    end
    
    it "should be able to follow" do
      @leader.should_not be_followed(@follower)
      @follower.follow(@leader)
      @leader.should be_followed(@follower)
    end

    it "should be able to unfollow" do
      @follower.follow(@leader)
      @leader.should be_followed(@follower)
      @follower.unfollow(@leader)
      @leader.should_not be_followed(@follower)      
    end
  end
end
