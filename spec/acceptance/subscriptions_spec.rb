require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Subscriptions", %q{
  In order to participate in conversations
  As a registered user
  I want to be able to subscribe/unsubscribe conversations
} do


  background do
    @user = active_user
    login_as_user @user
  end


  scenario "registered user creates a public/private Convo which results in subscribing to that convo as well" do
    @convo = Convo.make(:user => @user, :title => "my new convo", :privacy => "public")
    visit user_subscriptions_path @user
    page.should containt_content"my new convo"
  end
end
