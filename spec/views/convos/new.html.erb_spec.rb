require 'spec_helper'

describe "convos/new.html.erb" do
  before(:each) do
    assign(:convo, stub_model(Convo,
      :new_record? => true
    ))
  end

  it "renders new convo form" do
    render

    response.should have_selector("form", :action => convos_path, :method => "post") do |form|
    end
  end
end
