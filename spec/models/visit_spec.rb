require 'spec_helper'

describe Visit do
  describe "remarkable" do
    before(:each) do
      @visit = Factory(:visit)
    end 
  
    # columns
    #----------------------------------------------------------------------
    it { should have_column :user_id,  type: :integer, :null => false }
    it { should have_column :convo_id, type: :integer, :null => false }
    it { should have_column :visits_count, type: :integer, null: false, default: 1 }
    it { should have_column :created_at, :type => :datetime }
    it { should have_column :updated_at, :type => :datetime }

    # indexes
    #----------------------------------------------------------------------
    it { should have_index :user_id }
    it { should have_index :convo_id }
    it { should have_index :created_at }
        
    # validations
    #----------------------------------------------------------------------
    it { should validate_presence_of :user_id }
    it { should validate_presence_of :convo_id }
    it { should validate_presence_of :visits_count }
    it { should validate_uniqueness_of :user_id, :scope => :convo_id }
    
    # associations
    #----------------------------------------------------------------------
    it { should belong_to :user }
    it { should belong_to :convo }    
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
      end
      @user.reload
      @user.visits.count.should == 100
      # and the first item pushed out
      @user.visits.should_not include first_visit
    end    

    it "should increment visits_count" do
      convo = Convo.all[0]      
      @user.visit convo
      @user.visits.find_by_convo_id(convo.id).visits_count.should == 2
    end
 
  end


end
