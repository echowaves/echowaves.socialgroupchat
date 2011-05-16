require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Convos", %q{
  In order to chat
  As a registered user
  I want to be able to create a convo
  } do


    scenario "registered user creates a social Convo" do
      @convo_title = "my new convo"
      @user = login_new
      click_link "new convo"
      fill_in "convo_title", :with => @convo_title
      choose('convo_privacy_level_1')
      click_button("convo_submit")
      page.should have_content "Convo was successfully created."        
      click_link "nav_convos_link"
      page.should have_content @convo_title

      click_link "logout"
      click_link "nav_convos_link"
      page.should have_content @convo_title
    end


    scenario "registered user creates a confidential Convo" do
      @convo_title = "my new convo"
      @user = login_new
      click_link "new convo"
      fill_in "convo_title", :with => @convo_title
      choose('convo_privacy_level_0')
      click_button("convo_submit")
      page.should have_content "Convo was successfully created."        
      click_link "nav_convos_link"
      page.should_not have_content @convo_title

      pending "this should be on the convos page, not on the subscriptions page"

      click_link "nav_subscriptions_link"
      page.should have_content @convo_title

      click_link "logout"
      click_link "nav_convos_link"
      page.should_not have_content @convo_title
    end


    scenario "test convos pagination" do
      26.times do |i|
        Factory(:convo, :title => "Convo #{i}", :privacy_level => 1)
      end
      visit convos_path
      page.should have_content "Convo 25"

      page.should have_content "Next"
      page.should have_no_content "Prev"
      page.should have_no_content "Convo 0"
      click_link "Next"
      page.should have_content "Convo 0"
      page.should_not have_content "Convo 25"
      page.should have_no_content "Next"
      page.should have_content "Prev"
    end

    scenario "test convos subscribe/ubsubscribe stays on the same page" do
      @user = login_new
      100.times do |i|
        Factory(:convo, :owner => @user, :title => "Convo #{i}", :privacy_level => 1)
      end
      visit convos_path
      click_link "Next"
      click_link "Next"
      page.should have_content "Convo 49"
      click_link "unsubscribe"
      page.should have_content "Convo 49"
      click_link "subscribe"
      page.should have_content "Convo 49"
      current_path.should == convos_path
    end


    scenario "visitor can't create a Convo" do
      visit "/"
      page.should_not have_link "new convo"  
      visit new_convo_path
      page.should have_content "You need to sign in or sign up before continuing."
    end


    scenario "owner can visit his own confidential convos" do
      @user = login_new
      @confidential_convo = Factory(:convo, :owner => @user, :title => "my confidential convo", :privacy_level => 0)
      visit convo_path(@confidential_convo)
      current_path.should == convo_path(@confidential_convo)
      page.should have_content "my confidential convo"
    end


    scenario "owner can visit his own social convos" do
      @user = login_new
      @social_convo = Factory(:convo, :owner => @user, :title => "my social convo", :privacy_level => 1)
      visit convo_path(@social_convo)
      current_path.should == convo_path(@social_convo)
      page.should have_content "my social convo"
    end


    scenario "user can't access a confidential convo he don't follows" do
      @user = login_new
            
      @other_user = active_user
      @other_user_convo = Factory(:convo, :owner => @other_user, :title => "other guy's confidential convo", :privacy_level => 0)

      visit convo_path(@other_user_convo)
      current_path.should == convos_path
      page.should have_content("Sorry but this convo is confidential")
    end
    
    
    scenario "user can access a social convo" do
      @user = login_new
            
      @other_user = active_user
      @other_user_convo = Factory(:convo, :owner => @other_user, :title => "other guy's social convo", :privacy_level => 1)

      visit convo_path(@other_user_convo)
      current_path.should == convo_path(@other_user_convo)
      page.should_not have_content("Sorry but this convo is confidential")
      page.should have_content("other guy's social convo")
    end

    
    scenario "user can access a confidential convo he follows" do
      @user = login_new
            
      @other_user = active_user
      @other_user_convo = Factory(:convo, :owner => @other_user, :title => "other guy's confidential convo", :privacy_level => 0)

      Factory(:subscription, :user => @user, :convo => @other_user_convo) 

      visit convo_path(@other_user_convo)
      current_path.should == convo_path(@other_user_convo)
      page.should_not have_content("Sorry but this convo is confidential")
      page.should have_content("other guy's confidential convo")
    end


    scenario "visitor can access social convo" do
      @other_user = active_user

      @other_user_convo = Factory(:convo, :owner => @other_user, :title => "other guy's social convo", :privacy_level => 1)

      visit convo_path(@other_user_convo)

      current_path.should == convo_path(@other_user_convo)
      page.should have_content("other guy's social convo")
    end


    scenario "visitor can't access confidential convo" do
      @other_user = active_user

      @other_user_convo = Factory(:convo, :owner => @other_user, :title => "other guy's confidential convo", :privacy_level => 0)

      visit convo_path(@other_user_convo)

      current_path.should == convos_path
      page.should have_content("Sorry but this convo is confidential")
    end
    
    
    scenario "visitor should not see the subscriptions links in the convos list" do
      @other_user = active_user

      @other_user_convo = Factory(:convo, :owner => @other_user, :title => "other guy's confidential convo", :privacy_level => 0)

      visit convos_path

      find('#convos_list').should_not have_content("subscribe")
    end
    

    scenario "I can subscribe to a social convo from the convos list" do
      @user = login_new
            
      @other_user = active_user
      @other_user_convo = Factory(:convo, :owner => @other_user, :title => "other guy's social convo", :privacy_level => 1)

      visit convos_path

      click_link "subscribe"

      pending "this should be on the convos page, not on the subscriptions page"
      
      visit user_subscriptions_path(@user)
      
      page.should have_content("other guy's social convo")
    end


    scenario "I can unsubscribe from a convo from the convos list" do
      @user = login_new
            
      @other_user = active_user
      @other_user_convo = Factory(:convo, :owner => @other_user, :title => "other guy's social convo", :privacy_level => 1)

      Factory(:subscription, :user => @user, :convo => @other_user_convo) 

      visit convos_path
      
      click_link "unsubscribe"
      pending "this should be on the convos page, not on the subscriptions page"
      visit user_subscriptions_path(@user)
      page.should_not have_content("other guy's social convo")
    end


    scenario "I can access a confidential convo if I have an invitation" do
      @user = login_new

      @other_user = active_user
      @other_user_convo = Factory(:convo, :owner => @other_user, :title => "other guy's confidential convo", :privacy_level => 0)

      Factory(:invitation, :user => @user, :convo => @other_user_convo)

      visit convo_path(@other_user_convo)
    
      current_path.should == convo_path(@other_user_convo)
      find("#convo_header").should have_content("other guy's confidential convo")
    end

  end
