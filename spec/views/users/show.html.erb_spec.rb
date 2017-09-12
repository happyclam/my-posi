require 'spec_helper'

describe "users/show" do
  before(:each) do
    @user = assign(:user, stub_model(User,
      :name => "Name",
      :provider => "Provider",
      :screen_name => "Screen Name",
      :uid => "Uid"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Provider/)
    rendered.should match(/Screen Name/)
    rendered.should match(/Uid/)
  end
end
