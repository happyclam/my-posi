require 'spec_helper'

describe "strategies/show" do
  before(:each) do
    @strategy = assign(:strategy, stub_model(Strategy,
      :name => "Name",
      :draw_type => 1,
      :range => 2,
      :interest => 1.5,
      :sigma => 1.5
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
  end
end
