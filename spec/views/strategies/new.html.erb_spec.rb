require 'spec_helper'

describe "strategies/new" do
  before(:each) do
    assign(:strategy, stub_model(Strategy,
      :name => "MyString",
      :draw_type => 1,
      :range => 1,
      :interest => 1.5,
      :sigma => 1.5
    ).as_new_record)
  end

  it "renders new strategy form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", strategies_path, "post" do
      assert_select "input#strategy_name[name=?]", "strategy[name]"
      assert_select "input#strategy_draw_type[name=?]", "strategy[draw_type]"
      assert_select "input#strategy_range[name=?]", "strategy[range]"
      assert_select "input#strategy_interest[name=?]", "strategy[interest]"
      assert_select "input#strategy_sigma[name=?]", "strategy[sigma]"
    end
  end
end
