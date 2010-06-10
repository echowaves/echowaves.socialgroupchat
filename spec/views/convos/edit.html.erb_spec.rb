require 'spec_helper'

describe "convos/edit.html.erb" do
  before(:each) do
    assign(:convo, @convo = stub_model(Convo,
      :new_record? => false
    ))
  end

  it "renders the edit convo form" do
    render

    response.should have_selector("form", :action => convo_path(@convo), :method => "post") do |form|
    end
  end
end
