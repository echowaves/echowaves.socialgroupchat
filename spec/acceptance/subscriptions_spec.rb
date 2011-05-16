require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Subscriptions", %q{
  In order to participate in conversations
  As a registered user
  I want to be able to subscribe/unsubscribe conversations
} do


  background do
    @user = login_new
  end


  scenario "registered user creates a social Convo which results in subscribing to that convo as well" do
    @convo = Factory(:convo, :owner => @user, :title => "my new convo", :privacy_level => 1)
    pending "this should be on the convos page, not on the subscriptions page"
    visit user_subscriptions_path @user
    page.should have_content"my new convo"
  end


  scenario "registered user creates a private Convo which results in subscribing to that convo as well" do
    @convo = Factory(:convo, :owner => @user, :title => "my new convo", :privacy_level => 0)
    pending "this should be on the convos page, not on the subscriptions page"
    visit user_subscriptions_path @user
    page.should have_content"my new convo"
  end
  
  
end
