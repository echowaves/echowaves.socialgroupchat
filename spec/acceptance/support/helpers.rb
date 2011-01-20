module HelperMethods
  # Put helper methods you need to be available in all tests here.
  def active_user(params={})
    user = User.make(params)    
    user.confirmed_at = Time.new
    user.save!
    user
  end

  # def ew_admin_user(params={})
  #   user = active_user(params)
  #   user.make_ew_admin!
  #   user
  # end

  def login(username, password = 'changeme')
    visit destroy_user_session_path
    visit new_user_session_path
    fill_in "user_username", :with => username
    fill_in "user_password", :with => password
    click_button "user_submit"
  end
  
  def login_as_user(user)
    login(user.username, 'changeme')
  end
end

RSpec.configuration.include HelperMethods, :type => :acceptance
