require 'spec_helper'

describe "strategies/index" do
  before(:each) do
    assign(:strategies, [
      stub_model(Strategy,
        :name => "Name",
        :draw_type => 1,
        :range => 2,
        :interest => 1.5,
        :sigma => 1.5
      ),
      stub_model(Strategy,
        :name => "Name",
        :draw_type => 1,
        :range => 2,
        :interest => 1.5,
        :sigma => 1.5
      )
    ])
  end

  it "renders a list of strategies" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
  end
end
