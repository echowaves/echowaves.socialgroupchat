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
    @convo = Convo.make(:user => @user, :title => "my new convo", :privacy => "public")
    visit user_subscriptions_path @user
    page.should have_content"my new convo"
  end


  scenario "registered user creates a private Convo which results in subscribing to that convo as well" do
    @convo = Convo.make(:user => @user, :title => "my new convo", :privacy => "private")
    visit user_subscriptions_path @user
    page.should have_content"my new convo"
  end


  scenario "test subscriptions pagination" do
    21.times do |i|
      Convo.make(:user => @user, :title => "Convo #{i}.", :created_at => i*1000)
    end
    visit user_subscriptions_path @user
    page.should have_content"Convo 20."
    page.should have_content"Next"
    page.should have_content"Previous"
    page.should have_no_content"Convo 0."
    click_link "Next"
    page.should have_no_content"Convo 20."
    page.should have_content"Convo 0."
  end
  
  
end
