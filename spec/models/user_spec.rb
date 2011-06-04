require 'spec_helper'

describe User do

  describe "remarkable" do
    before(:each) do
      @user = Factory(:user)
    end

    # columns
    #----------------------------------------------------------------------
    it { should have_db_column(:username).of_type(:string).with_options(:limit => 128) }
    it { should have_db_column(:email).of_type(:string).with_options(:limit => 255, :default => '', :null => false) }
    it { should have_db_column(:encrypted_password).of_type(:string).with_options(:limit => 128, :default => '', :null => false) }
    it { should have_db_column(:confirmation_token).of_type(:string).with_options(:limit => 255) }
    it { should have_db_column(:confirmed_at).of_type(:datetime) }
    it { should have_db_column(:confirmation_sent_at).of_type(:datetime) }
    it { should have_db_column(:reset_password_token).of_type(:string).with_options(:limit => 255) }
    it { should have_db_column(:remember_token).of_type(:string).with_options(:limit => 255) }
    it { should have_db_column(:remember_created_at).of_type(:datetime) }
    it { should have_db_column(:sign_in_count).of_type(:integer).with_options(:default => 0) }
    it { should have_db_column(:current_sign_in_at).of_type(:datetime) }
    it { should have_db_column(:last_sign_in_at).of_type(:datetime) }
    it { should have_db_column(:current_sign_in_ip).of_type(:string).with_options(:limit => 255) }
    it { should have_db_column(:last_sign_in_ip).of_type(:string).with_options(:limit => 255) }
    it { should have_db_column(:password_salt).of_type(:string).with_options(:limit => 255) }
    it { should have_db_column(:subscriptions_count).of_type(:integer).with_options(:default => 0) }    
    it { should have_db_column(:created_at).of_type(:datetime) }
    it { should have_db_column(:updated_at).of_type(:datetime) }

    # indexes
    #----------------------------------------------------------------------
    it { should have_db_index :username }
    it { should have_db_index :email }
    it { should have_db_index :confirmation_token }
    it { should have_db_index :reset_password_token }
    it { should have_db_index :created_at }
     
    # validations
    #----------------------------------------------------------------------
    it { should validate_presence_of :username }
    it { should validate_uniqueness_of :username }

    it { should validate_uniqueness_of( :username) }
    it { should validate_uniqueness_of( :email) }
    it { should validate_presence_of :email }
    it { should     allow_value("tester@example.com").for(:email)}
    it { should_not allow_value("tester@example").for(:email)}
    it { should_not allow_value("tester@example").for(:email)}
    it { should_not allow_value("tester_example.com").for(:email)}
    it { should_not allow_value("tester_example_com").for(:email)}
    # associations
    #----------------------------------------------------------------------
    it { should have_many :subscriptions }
    it { should have_many(:subscribed_convos).through(:subscriptions) }
    
    it { should have_many :invitations }
    it { should have_many(:convo_invites).through(:invitations) }
    
    it { should have_many :followerships }
    it { should have_many(:followers).through(:followerships) }
    it { should have_many :leaderships }
    it { should have_many(:leaders).through(:leaderships) }
    
    it { should have_many :visits }
    it { should have_many(:visited_convos).through(:visits) }
    it { should have_many :convos }
    it { should have_many :messages }

  end


  it "should produce gravatar url" do
    user = Factory(:user, :email => "test@example.com")
    user.gravatar.should include("gravatar.com/avatar/55502f40dc8b7c769880b10874abc9d0.jpg")      
  end


end
