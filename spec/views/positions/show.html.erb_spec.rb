require 'spec_helper'

describe "positions/show" do
  before(:each) do
    @position = assign(:position, stub_model(Position,
      :distinct => 1,
      :sale => 2,
      :exercise => 3,
      :maturity => 1.5,
      :number => 4,
      :unit => "9.99"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/3/)
    rendered.should match(/1.5/)
    rendered.should match(/4/)
    rendered.should match(/9.99/)
  end
end
