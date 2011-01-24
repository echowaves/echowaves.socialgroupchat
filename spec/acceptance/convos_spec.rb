require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Convos", %q{
  In order to chat
  As a registered user
  I want to be able to create a convo
  } do


    scenario "registered user creates a public Convo" do
      @convo_title = "my new convo"
      @user = active_user
      login_as_user @user
      click_link "new convo"
      fill_in "convo_title", :with => @convo_title
      choose('convo_privacy_public')
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
      @user = active_user
      login_as_user @user
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
      @user = active_user
      login_as_user @user
      21.times do |i|
        Convo.make(:user => @user, :title => "Convo #{i}", :created_at => i*1000)
      end
      visit convos_path
      page.should have_content "Convo 20"
      page.should have_content "Next"
      page.should have_content "Previous"
      page.should_not have_content "Convo 0"
      click_link "Next"
      page.should have_content "Convo 0"
      page.should_not have_content "Convo 20"
    end


    scenario "visitor can't create a Convo" do
      visit "/"
      page.should_not have_link "new convo"  
      visit new_convo_path
      page.should have_content "You need to sign in or sign up before continuing."
    end


    scenario "owner can visit his own private convos" do
      @user = active_user
      login_as_user @user
      @private_convo = Convo.make(:user => @user, :title => "my private convo", :privacy => "private")
      visit convo_path(@private_convo)
      URI.parse(current_url).path.should eq convo_path(@private_convo)
      page.should have_content "my private convo"
    end


    scenario "owner can visit his own public convos" do
      @user = active_user
      login_as_user @user
      @public_convo = Convo.make(:user => @user, :title => "my public convo", :privacy => "public")
      visit convo_path(@public_convo)
      URI.parse(current_url).path.should eq convo_path(@public_convo)
      page.should have_content "my public convo"
    end


    scenario "user can't access a private convo he don't follows" do
      @user = active_user
      login_as_user @user
            
      @other_user = active_user
      @other_user_convo = Convo.make(:user => @other_user, :title => "other guy's private convo", :privacy => "private")

      visit convo_path(@other_user_convo)
      URI.parse(current_url).path.should eq convos_path
      page.should have_content("Sorry but this convo is private")
    end
    
    
    scenario "user can access a public convo" do
      @user = active_user
      login_as_user @user
            
      @other_user = active_user
      @other_user_convo = Convo.make(:user => @other_user, :title => "other guy's public convo", :privacy => "public")

      visit convo_path(@other_user_convo)
      URI.parse(current_url).path.should eq convo_path(@other_user_convo)
      page.should_not have_content("Sorry but this convo is private")
      page.should have_content("other guy's public convo")
    end

    
    scenario "user can access a private convo he follows" do
      @user = active_user
      login_as_user @user
            
      @other_user = active_user
      @other_user_convo = Convo.make(:user => @other_user, :title => "other guy's private convo", :privacy => "private")

      Subscription.make(:user => @user, :convo => @other_user_convo) 

      visit convo_path(@other_user_convo)
      URI.parse(current_url).path.should eq convo_path(@other_user_convo)
      page.should_not have_content("Sorry but this convo is private")
      page.should have_content("other guy's private convo")
    end
    
  end
