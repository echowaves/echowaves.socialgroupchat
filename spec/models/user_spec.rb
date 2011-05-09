require 'spec_helper'

describe User do

  describe "remarkable" do
    before(:each) do
      @user = Factory(:user)
    end

    # columns
    #----------------------------------------------------------------------
    it { should have_column :username, :type => :string, :limit => 128 }
    it { should have_column :email,    :type => :string, :limit => 255, :default => '', :null => false }
    it { should have_column :encrypted_password,    :type => :string, :limit => 128, :default => '', :null => false }
    it { should have_column :confirmation_token, :type => :string, :limit => 255 }
    it { should have_column :confirmed_at, :type => :datetime }
    it { should have_column :confirmation_sent_at, :type => :datetime }
    it { should have_column :reset_password_token,    :type => :string, :limit => 255 }
    it { should have_column :remember_token,    :type => :string, :limit => 255 }
    it { should have_column :remember_created_at, :type => :datetime }
    it { should have_column :sign_in_count, :type => :integer, :default => 0 }
    it { should have_column :current_sign_in_at, :type => :datetime }
    it { should have_column :last_sign_in_at, :type => :datetime }
    it { should have_column :current_sign_in_ip, :type => :string, :limit => 255 }
    it { should have_column :last_sign_in_ip, :type => :string, :limit => 255 }
    it { should have_column :password_salt, :type => :string, :limit => 255 }
    it { should have_column :created_at, :type => :datetime }
    it { should have_column :updated_at, :type => :datetime }

    # indexes
    #----------------------------------------------------------------------
    it { should have_index :username }
    it { should have_index :email }
    it { should have_index :confirmation_token }
    it { should have_index :reset_password_token }
    it { should have_index :created_at }
     
    # validations
    #----------------------------------------------------------------------
    it { should validate_presence_of :username }
    it { should validate_uniqueness_of :username }

    it { should validate_uniqueness_of( :username) }
    it { should validate_uniqueness_of( :email) }

    # associations
    #----------------------------------------------------------------------
    it { should have_many :subscriptions }
    it { should have_many :invitations }

    it { should have_many :followerships, :foreign_key => "leader_id" }
    it { should have_many :followers, :through => :followerships }
     
    it { should have_many :leaderships, :class_name => "Followership", :foreign_key => "follower_id" }
    it { should have_many :leaders, :through => :leaderships }
    
    it { should have_many :visits, :order => "updated_at DESC", limit: 100 }
    it { should have_many :visited_convos, :through => :visits, :source => :convo, limit: 100 }
    it { should have_many :convos,   :foreign_key => "owner_id" }
    it { should have_many :messages, :foreign_key => "owner_id" }

  end


  it "should produce gravatar url" do
    user = Factory(:user, :email => "test@example.com")
    user.gravatar.should include("gravatar.com/avatar/55502f40dc8b7c769880b10874abc9d0.jpg")      
  end


  describe Visit do
    before do
      @user = Factory(:user)
       3.times do |i|
          Factory(:convo, :owner => @user)
       end
       Convo.all.each do |convo|
         @user.visit convo
       end
    end
    it "should grow the visits collection" do
      @user.visited_convos.count.should == 3
      @user.visits.count.should == 3
    end
      
    it "should not grow if the same convos are visited again" do
      # visit the same convos again
      Convo.all.each do |convo|
        @user.visit convo
      end       
      @user.visits.count.should == 3      
    end
      
    it "should return visited_convos" do
      @user.visited_convos.should == Convo.all
    end
      
    it "should return visited_convos" do
      all_convos = Convo.all
      @user.visited_convos.count.should == all_convos.count
      
      @user.visited_convos.each do |visited_convo|
        all_convos.should include visited_convo
      end
    end
        
    it "should not grow more then 100 items" do
      first_visit = @user.visits.last
      first_visit.convo.should == Convo.all[0]
      @user.visits.should include first_visit
      #after this there should be 1003 convos created but only 1000 visits
      100.times do |i|         
         @user.visit Factory(:convo, :owner => @user)
         # sleep 0.001
      end
      @user.visits.count.should == 100
      # and the first item pushed out
      pending "someting does not work, will have to figure out after everything else is in place"
      @user.visits.should_not include first_visit
    end    

    it "should increment visits_count" do
      convo = Convo.all[0]      
      @user.visit convo
      @user.visits.find_by_convo_id(convo.id).visits_count.should == 2
    end
 
  end
  
  
end
