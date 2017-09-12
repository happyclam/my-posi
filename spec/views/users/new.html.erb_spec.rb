require 'spec_helper'

describe "users/new" do
  before(:each) do
    assign(:user, stub_model(User,
      :name => "MyString",
      :provider => "MyString",
      :screen_name => "MyString",
      :uid => "MyString"
    ).as_new_record)
  end

  it "renders new user form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", users_path, "post" do
      assert_select "input#user_name[name=?]", "user[name]"
      assert_select "input#user_provider[name=?]", "user[provider]"
      assert_select "input#user_screen_name[name=?]", "user[screen_name]"
      assert_select "input#user_uid[name=?]", "user[uid]"
    end
  end
end
