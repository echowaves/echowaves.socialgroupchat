require 'spec_helper'

describe Message do

  describe "remarkable" do
    before(:each) do
      @message = Factory(:message)
    end

    # columns
    #----------------------------------------------------------------------
    it { should have_column :uuid, :type => :string, :limit => 255, :null => false }
    it { should have_column :body, :type => :string, :limit => 256000, :null => false }
    it { should have_column :owner_id, :type  => :integer, :null => false }
    it { should have_column :convo_id, :type  => :integer, :null => false }
    it { should have_column :created_at, :type => :datetime }
    it { should have_column :updated_at, :type => :datetime }

    # indexes
    #----------------------------------------------------------------------
    it { should have_index :owner_id }
    it { should have_index :convo_id }
    it { should have_index :created_at }

    # validations
    it { should validate_presence_of :uuid }
    it { should validate_presence_of :body }
    it { should validate_presence_of :owner }
    it { should validate_presence_of :convo }
    it { should validate_length_of :uuid, :maximum => 255 }
    it { should validate_length_of :body, :maximum => 256000 }
    
    # associations
    #----------------------------------------------------------------------
    it { should belong_to :owner, class_name: "User" }
    it { should belong_to :convo, :counter_cache => true }
    #----------------------------------------------------------------------

  end

  
  
  describe "business logic" do
    before do
      @user = Factory(:user)
      @convo = Factory(:convo, :owner => @user)
      @message = Factory(:message, :convo => @convo, :owner => @user, :body => "not a zero length body")
    end
  
  
    it "should reference convo and user, and contain body" do
      @message.owner.should == @user
      @message.convo.should == @convo
      @message.body.length.should > 0
    end
  
  
  end


end
