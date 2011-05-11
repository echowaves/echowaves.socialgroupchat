require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Convos", %q{
  In order to chat
  As a registered user
  I want to be able to create a convo
  } do


    scenario "registered user creates a public Convo" do
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


    scenario "registered user creates a private Convo" do
      @convo_title = "my new convo"
      @user = login_new
      click_link "new convo"
      fill_in "convo_title", :with => @convo_title
      choose('convo_privacy_private')
      click_button("convo_submit")
      page.should have_content "Convo was successfully created."        
      click_link "nav_convos_link"
      page.should_not have_content @convo_title

      click_link "nav_subscriptions_link"
      page.should have_content @convo_title

      click_link "logout"
      click_link "nav_convos_link"
      page.should_not have_content @convo_title
    end


    scenario "test convos pagination" do
      @user = login_new
      26.times do |i|
        Factory(:convo, :owner => @user, :title => "Convo #{i}")
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
        Factory(:convo, :owner => @user, :title => "Convo #{i}")
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


    scenario "owner can visit his own private convos" do
      @user = login_new
      @private_convo = Factory(:convo, :owner => @user, :title => "my private convo", :privacy_level => 0)
      visit convo_path(@private_convo)
      current_path.should == convo_path(@private_convo)
      page.should have_content "my private convo"
    end


    scenario "owner can visit his own public convos" do
      @user = login_new
      @public_convo = Factory(:convo, :owner => @user, :title => "my public convo", :privacy_level => 1)
      visit convo_path(@public_convo)
      current_path.should == convo_path(@public_convo)
      page.should have_content "my public convo"
    end


    scenario "user can't access a private convo he don't follows" do
      @user = login_new
            
      @other_user = active_user
      @other_user_convo = Factory(:convo, :owner => @other_user, :title => "other guy's private convo", :privacy_level => 0)

      visit convo_path(@other_user_convo)
      current_path.should == convos_path
      page.should have_content("Sorry but this convo is private")
    end
    
    
    scenario "user can access a public convo" do
      @user = login_new
            
      @other_user = active_user
      @other_user_convo = Factory(:convo, :owner => @other_user, :title => "other guy's public convo", :privacy_level => 1)

      visit convo_path(@other_user_convo)
      current_path.should == convo_path(@other_user_convo)
      page.should_not have_content("Sorry but this convo is private")
      page.should have_content("other guy's public convo")
    end

    
    scenario "user can access a private convo he follows" do
      @user = login_new
            
      @other_user = active_user
      @other_user_convo = Factory(:convo, :owner => @other_user, :title => "other guy's private convo", :privacy_level => 0)

      Factory(:subscription, :user => @user, :convo => @other_user_convo) 

      visit convo_path(@other_user_convo)
      current_path.should == convo_path(@other_user_convo)
      page.should_not have_content("Sorry but this convo is private")
      page.should have_content("other guy's private convo")
    end


    scenario "visitor can access public convo" do
      @other_user = active_user

      @other_user_convo = Factory(:convo, :owner => @other_user, :title => "other guy's public convo", :privacy_level => 1)

      visit convo_path(@other_user_convo)

      current_path.should == convo_path(@other_user_convo)
      page.should have_content("other guy's public convo")
    end


    scenario "visitor can't access private convo" do
      @other_user = active_user

      @other_user_convo = Factory(:convo, :owner => @other_user, :title => "other guy's private convo", :privacy_level => 0)

      visit convo_path(@other_user_convo)

      current_path.should == convos_path
      page.should have_content("Sorry but this convo is private")
    end
    
    
    scenario "visitor should not see the subscriptions links in the convos list" do
      @other_user = active_user

      @other_user_convo = Factory(:convo, :owner => @other_user, :title => "other guy's private convo", :privacy_level => 0)

      visit convos_path

      find('#convos_list').should_not have_content("subscribe")
    end
    

    scenario "I can subscribe to a public convo from the convos list" do
      @user = login_new
            
      @other_user = active_user
      @other_user_convo = Factory(:convo, :owner => @other_user, :title => "other guy's public convo", :privacy_level => 1)

      visit convos_path

      click_link "subscribe"
      
      visit user_subscriptions_path(@user)
      
      page.should have_content("other guy's public convo")
    end


    scenario "I can unsubscribe from a convo from the convos list" do
      @user = login_new
            
      @other_user = active_user
      @other_user_convo = Factory(:convo, :owner => @other_user, :title => "other guy's public convo", :privacy_level => 1)

      Factory(:subscription, :user => @user, :convo => @other_user_convo) 

      visit convos_path
      
      click_link "unsubscribe"
      visit user_subscriptions_path(@user)
      page.should_not have_content("other guy's public convo")
    end


    scenario "I can access a private convo if I have an invitation" do
      @user = login_new

      @other_user = active_user
      @other_user_convo = Factory(:convo, :owner => @other_user, :title => "other guy's private convo", :privacy_level => 0)

      Factory(:invitation, :user => @user, :convo => @other_user_convo)

      visit convo_path(@other_user_convo)
    
      current_path.should == convo_path(@other_user_convo)
      find("#convo_header").should have_content("other guy's private convo")
    end

  end
