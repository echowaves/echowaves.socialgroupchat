require 'spec_helper'

describe "convos/new.html.erb" do
  before(:each) do
    assign(:convo, stub_model(Convo,
      :new_record? => true,
      :title => "MyString"
    ))
  end

  it "renders new convo form" do
    render

    response.should have_selector("form", :action => convos_path, :method => "post") do |form|
      form.should have_selector("input#convo_title", :name => "convo[title]")
    end
  end
end
