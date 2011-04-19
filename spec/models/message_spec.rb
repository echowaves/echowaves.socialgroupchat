require 'spec_helper'

describe Message do
  describe "mongoid-rspec" do
    it { should validate_presence_of :owner }

    it { should have_fields(:created_at, :updated_at).of_type(Time) }

    it { should belong_to(:owner).of_type(User) }
    it { should be_referenced_in :convo }
    it { should have_fields(:uuid, :body) }    

  end
  
  
  describe "business logic" do
    before do
      @user = User.make!(:username => "tester", :email => "test@example.com")
      @convo = Convo.make!(:title => "test convo", :owner => @user)
      @message = Message.create!(:convo => @convo, :owner => @user, :body => "not a zero length body")
    end


    it "should reference convo and user, and contain body" do
      @message.owner.should == @user
      @message.convo.should == @convo
      @message.body.length.should > 0
    end


  end


end
