require 'spec_helper'

describe Message do

  describe "remarkable" do
    before(:each) do
      @message = Factory(:message)
    end

    # columns
    #----------------------------------------------------------------------
    it { should have_db_column(:uuid).of_type(:string).with_options(:limit => 255, :null => false) }
    it { should have_db_column(:body).of_type(:string).with_options(:limit => 256000, :null => false) }
    it { should have_db_column(:owner_id).of_type(:integer).with_options(:null => false) }
    it { should have_db_column(:convo_id).of_type(:integer).with_options(:null => false) }
    it { should have_db_column(:created_at).of_type(:datetime) }
    it { should have_db_column(:updated_at).of_type(:datetime) }

    # indexes
    #----------------------------------------------------------------------
    it { should have_db_index :owner_id }
    it { should have_db_index :convo_id }
    it { should have_db_index :created_at }

    # validations
    it { should validate_presence_of :uuid }
    it { should validate_presence_of :body }
    it { should validate_presence_of :owner }
    it { should validate_presence_of :convo }
    it { should ensure_length_of(:uuid).is_at_most(255) }
    it { should ensure_length_of(:body).is_at_most(256000) }
    
    # associations
    #----------------------------------------------------------------------
    it { should belong_to :owner }
    it { should belong_to :convo }
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
