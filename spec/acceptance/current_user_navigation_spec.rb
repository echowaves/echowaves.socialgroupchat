require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Users List", %q{
  In order to make navigation easier
  As a registered and logged in user
  I want to be able to access recently visited and recently updated convos
} do

  before do
    @user_foo = active_user
    @user_bar = active_user
    
    @convo_foo = Factory(:convo, :owner => @user_foo, :title => "foos_convo", :privacy_level => 1)
    @convo_bar = Factory(:convo, :owner => @user_bar, :title => "bars_convo", :privacy_level => 1)
    
    @convo_foo.subscribe @user_foo
    @convo_foo.subscribe @user_bar

    @convo_bar.subscribe @user_foo
    @convo_bar.subscribe @user_bar    
  end
  

  scenario "logged in user can see recently updated convos", :js=>true do
    login_as_user @user_foo
    visit convo_path @convo_foo
    3.times { post_message }
    visit convo_path @convo_bar
    3.times { post_message }
    
    login_as_user @user_bar
    visit convo_path @convo_bar
    
    within 'div#updated_subscriptions' do
      page.should have_no_content 'bars_convo'
      page.should have_content 'foos_convo'
    end
  end
  
  
  scenario "non logged in user should not see any visited or updated convos", :js=>true do
    login_as_user @user_foo
    visit convo_path @convo_foo
    3.times { post_message }
    visit convo_path @convo_bar
    3.times { post_message }
    
    logout
    visit convo_path @convo_bar

    page.should have_no_css '#updated_subscriptions'
    page.should have_no_css '#visited_convos'    
  end

  private
  def post_message
    within '#convo_footer' do
      fill_in('message_area', :with => 'Really Long Text...' )
      find("#message_area").native.send_keys(:return)
    end    
  end

end
