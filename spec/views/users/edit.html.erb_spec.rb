require 'spec_helper'

describe "users/edit" do
  before(:each) do
    @user = assign(:user, stub_model(User,
      :name => "MyString",
      :provider => "MyString",
      :screen_name => "MyString",
      :uid => "MyString"
    ))
  end

  it "renders the edit user form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", user_path(@user), "post" do
      assert_select "input#user_name[name=?]", "user[name]"
      assert_select "input#user_provider[name=?]", "user[provider]"
      assert_select "input#user_screen_name[name=?]", "user[screen_name]"
      assert_select "input#user_uid[name=?]", "user[uid]"
    end
  end
end
