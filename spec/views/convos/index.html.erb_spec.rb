require 'spec_helper'

describe "convos/index.html.erb" do
  before(:each) do
    assign(:convos, [
      stub_model(Convo),
      stub_model(Convo)
    ])
  end

  it "renders a list of convos" do
    render
  end
end
