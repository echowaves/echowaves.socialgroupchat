require 'spec_helper'

describe "users/show.html.erb" do
  before(:each) do
    assign(:user, @user = stub_model(User)
  end

  it "renders attributes in <p>" do
    render
  end
end
