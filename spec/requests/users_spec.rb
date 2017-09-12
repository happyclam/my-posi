require 'rails_helper'

describe "Users" do
  before { visit users_path }
  it "should have the content 'みんなのポジション'" do
    visit users_path
    expect(page).to have_content('みんなのポジション')
  end
  it "should have the base title 'MyPosi'" do
    visit users_path
    expect(page).to have_title('MyPosi')
  end
end
describe "User pages" do
  describe "edit" do
    before do
      OmniAuth.config.test_mode = true
      @current_user = User.create(
                                  :uid => 12234,
                                  :provider => "twitter",
                                  :screen_name => "NickName",
                                  :name => "FirstName LastName"
                                  )
      OmniAuth.config.mock_auth[:twitter] = {
        "uid" => @current_user.uid,
        "provider" => @current_user.provider,
        "info" => {
          "nickname" => @current_user.screen_name,
          "name" => @current_user.name,
        },
      }
      subject {page}
    end
    after do
      OmniAuth.config.test_mode = false
    end
    it "gets edit form" do
      xhr :get, edit_user_path(@current_user)
      response.should be_success
    end
    it "編集リンク", :js => true do
      xhr :get, edit_user_path(@current_user)
      response.code.should == "200"
      # expect(page).to have_content(:screen_name)
      # expect(page).to have_content(:btn_update)
      # expect(page).to have_content(:btn_cancel)
    end
#     it "edit.js", :js => true do
#       xhr :get, edit_user_path(@current_user)
# #      fill_in "user[screen_name]", :with => @current_user.screen_name
# #      fill_in "screen_name", :with => @current_user.screen_name
#       fill_in "user_screen_name", :with => @current_user.screen_name
#       click_link (:btn_edit)
# #      response.should render_partial("users/_new_user")
# #      page.find('user[screen_name]').set(@current_user.screen_name)
# #      page.should have_content(@current_user.screen_name)
#     end
    it "update" do
#      xhr :put, :update, {:id => @current_user.id.to_s, :user => {:screen_name=>@current_user.screen_name}, :format => :js}
      # xhr :post, user_path(@current_user.id), user: {:screen_name => @current_user.screen_name}
      # response.code.should == "200"
      expect do
        xhr :patch, user_path(@current_user), user: {:screen_name => @current_user.screen_name}
      end.to change(User, :count).by(0)
      # expect do
      #   xhr :post, users_path, user: {:screen_name => @current_user.screen_name}
      # end.to change(User, :count).by(1)
    end
    it "delete" do
      expect do
        xhr :delete, user_path(@current_user)
      end.to change(User, :count).by(-1)
    end
  end
end
