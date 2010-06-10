require 'spec_helper'

describe "convos/index.html.erb" do
  before(:each) do
    assign(:convos, [
      stub_model(Convo,
        :title => "MyString"
      ),
      stub_model(Convo,
        :title => "MyString"
      )
    ])
  end

  it "renders a list of convos" do
    render
    response.should have_selector("tr>td", :content => "MyString".to_s, :count => 2)
  end
end
