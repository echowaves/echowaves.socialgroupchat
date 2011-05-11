require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Subscriptions", %q{
  In order to participate in conversations
  As a registered user
  I want to be able to subscribe/unsubscribe conversations
} do


  background do
    @user = login_new
  end


  scenario "registered user creates a public Convo which results in subscribing to that convo as well" do
    @convo = Factory(:convo, :owner => @user, :title => "my new convo", :privacy_level => 1)
    visit user_subscriptions_path @user
    page.should have_content"my new convo"
  end


  scenario "registered user creates a private Convo which results in subscribing to that convo as well" do
    @convo = Factory(:convo, :owner => @user, :title => "my new convo", :privacy_level => 0)
    visit user_subscriptions_path @user
    page.should have_content"my new convo"
  end


  scenario "test subscriptions pagination" do
    26.times do |i|
      Factory(:convo, :owner => @user, :title => "Convo #{i}.")
    end
    visit user_subscriptions_path @user
    page.should have_content"Convo 25."
    page.should have_content"Next"
    page.should have_no_content"Prev"
    page.should have_no_content"Convo 0."
    click_link "Next"
    page.should have_no_content"Convo 25."
    page.should have_content"Convo 0."
    page.should have_no_content"Next"
    page.should have_content"Prev"
  end
  
  
end
