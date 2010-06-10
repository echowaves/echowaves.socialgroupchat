require 'spec_helper'

describe "convos/show.html.erb" do
  before(:each) do
    assign(:convo, @convo = stub_model(Convo,
      :title => "MyString"
    ))
  end

  it "renders attributes in <p>" do
    render
    response.should contain("MyString")
  end
end
