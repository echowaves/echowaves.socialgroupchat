require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Messages", %q{
  In order to chat 
  As a registered user
  I want to be able to post a message to existing convo
} do

  background do
    @user = login_new
  end


  scenario "registered user can post a message to a public convo", :js => true do
    @convo = Convo.make(:user => @user, :privacy => 'public')
    visit convo_path(@convo)
    within '#convo_footer' do
      fill_in('message_area', :with => 'Really Long Text...' )
      find("#message_area").native.send_keys(:return)
    end

    within '#messages' do
      page.should have_content 'Really Long Text...'
    end
    #now lets reload the page and the message should still be on the same place
    visit convo_path(@convo)
    
    within '#messages' do
      page.should have_content 'Really Long Text...'
    end

  end
end
