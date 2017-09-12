require 'spec_helper'

describe "positions/index" do
  before(:each) do
    assign(:positions, [
      stub_model(Position,
        :distinct => 1,
        :sale => 2,
        :exercise => 3,
        :maturity => 1.5,
        :number => 4,
        :unit => "9.99"
      ),
      stub_model(Position,
        :distinct => 1,
        :sale => 2,
        :exercise => 3,
        :maturity => 1.5,
        :number => 4,
        :unit => "9.99"
      )
    ])
  end

  it "renders a list of positions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
  end
end
