module HelperMethods
  # Put helper methods you need to be available in all tests here.
  def active_user(params={})
    user = Factory(:user, params)
    user.confirmed_at = Time.new
    user.save!
    user
  end

  # def ew_admin_user(params={})
  #   user = active_user(params)
  #   user.make_ew_admin!
  #   user
  # end

  def login(username, password = 'password')
    visit destroy_user_session_path
    visit new_user_session_path
    fill_in "user_username", :with => username
    fill_in "user_password", :with => password
    click_button "Sign in"
  end
  
  def login_as_user(user)
    login(user.username)
  end
  
  def login_new
    @user = active_user
    login_as_user @user
    @user
  end
  
  def logout
    visit destroy_user_session_path
  end
end

RSpec.configuration.include HelperMethods, :type => :acceptance
