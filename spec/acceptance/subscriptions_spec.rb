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
    visit convos_path
    page.should have_content"my new convo"
  end


  scenario "registered user creates a private Convo which results in subscribing to that convo as well" do
    @convo = Factory(:convo, :owner => @user, :title => "my new convo", :privacy_level => 0)
    visit convos_path
    page.should have_content"my new convo"
  end
  
  
end
