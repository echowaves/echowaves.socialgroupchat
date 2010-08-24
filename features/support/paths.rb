module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the home\s?page/
      '/'

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))
     when /home page/
       root_path
     when /sign up page/
       new_user_registration_path
     when /login page/
       new_user_session_path
     when /sign out link/
       destroy_user_session_path
     when /forgotten password page/
       new_user_password_path
     when /resend confirmation page/
       new_user_confirmation_path
     when /edit user link/
       edit_user_registration_path
     when /convos page/
       convos_path
     when /create new convo page/
       new_convo_path
     when /"(.+)" convo page/
       convo = Convo.find(:first, :conditions => {:title => $1})
       convo_path(convo)
     when /messages page for "(.+)" convo/
       convo = Convo.find(:first, :conditions => {:title => $1})
       convo_messages_path(convo)

    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
