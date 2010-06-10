require 'spec_helper'

describe "convos/show.html.erb" do
  before(:each) do
    assign(:convo, @convo = stub_model(Convo)
  end

  it "renders attributes in <p>" do
    render
  end
end
