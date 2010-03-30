require 'spec_helper'

describe "users/new.html.erb" do
  before(:each) do
    assign(:user, stub_model(User,
      :new_record? => true
    ))
  end

  it "renders new user form" do
    render

    response.should have_selector("form", :action => users_path, :method => "post") do |form|
    end
  end
end
