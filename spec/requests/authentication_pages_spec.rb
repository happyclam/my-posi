require 'spec_helper'
require 'rails_helper'

describe "Authentication" do
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
  end
  after do
    OmniAuth.config.test_mode = false
  end
  describe "signin" do
    it "after signin" do
      visit "/auth/twitter"
      subject { page }
      expect(page).to have_content('login succeeded')
      expect(page).to have_content(@current_user.screen_name)
      expect(page).to have_link('<編集>', href: edit_user_path(@current_user))
      expect(page).to have_link('<削除>', href: user_path(@current_user))
      expect(page).to have_link('logout', href: logout_path)
    end
  end
  describe "signout" do
    it "after signout" do
      visit logout_path
      subject { page }
      expect(page).to have_no_content(@current_user.screen_name)
      expect(page).to have_no_link('<編集>', href: edit_user_path(@current_user))
    end
  end
end

# describe "Authentication" do
#   subject { page }
#   describe "signin page" do
#     before { visit users_path}
#     it { should have_content('Twitterでログイン') }
#   end
#   describe "with twitter oauth" do
#     let(:user) { FactoryGirl.create(:user) }
#     before do
#       click_button "Twitterでログイン"
#     end
#     before { login user }
#     it { should have_title(user.name) }
#     it { should have_link('Profile', href: user_path(user)) }
#     it { should have_link('Settings', href: edit_user_path(user)) }
#     it { should have_link('Profile', href: logout_path) }
#   end
# end
