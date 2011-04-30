require 'spec_helper'

describe Subscription do
  describe "mongoid-rspec" do
    it { should have_fields(:created_at, :updated_at).of_type(Time) }
    it { should have_field(:last_read_message_id) }
    it { should have_field(:new_messages_count).of_type(Integer) }

    it { should validate_presence_of :convo }
    it { should validate_presence_of :user }


    it { should be_referenced_in :convo }
    it { should be_referenced_in :user }
  end


  describe "business logic" do
    before do
      @user = User.make
      @convo = Convo.make(:owner => @user)
      @subscription = Subscription.create!(:convo => @convo, :user => @user)
    end

    it "should reference convo and user" do
      @subscription.user.should == @user
      @subscription.convo.should == @convo
    end

  end


end
