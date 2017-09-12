require 'spec_helper'

describe "positions/new" do
  before(:each) do
    assign(:position, stub_model(Position,
      :distinct => 1,
      :sale => 1,
      :exercise => 1,
      :maturity => 1.5,
      :number => 1,
      :unit => "9.99"
    ).as_new_record)
  end

  it "renders new position form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", positions_path, "post" do
      assert_select "input#position_distinct[name=?]", "position[distinct]"
      assert_select "input#position_sale[name=?]", "position[sale]"
      assert_select "input#position_exercise[name=?]", "position[exercise]"
      assert_select "input#position_maturity[name=?]", "position[maturity]"
      assert_select "input#position_number[name=?]", "position[number]"
      assert_select "input#position_unit[name=?]", "position[unit]"
    end
  end
end
