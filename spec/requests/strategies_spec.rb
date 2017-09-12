require 'spec_helper'
require 'rails_helper'

describe "Strategies" do
  subject {page}
  
  let(:user) {FactoryGirl.create(:user)}
  # before do
  #   OmniAuth.config.test_mode = true
  #   @current_user = User.create(
  #     :uid => 12234,
  #     :provider => "twitter",
  #     :screen_name => "NickName",
  #     :name => "FirstName LastName"
  #   )
  #   OmniAuth.config.mock_auth[:twitter] = {
  #     "uid" => @current_user.uid,
  #     "provider" => @current_user.provider,
  #     "info" => {
  #       "nickname" => @current_user.screen_name,
  #       "name" => @current_user.name,
  #     },
  #   }
  # end
  # after do
  #   OmniAuth.config.test_mode = false
  # end

  describe "strategy creation" do
    before {visit strategies_path(user_id: user.id)}
    describe "with invalid information" do
      it "should not create a strategy" do
        expect {click_button "Post"}.not_to change(Strategy, :count)
#        expect {find('input[type="submit"]').click}.not_to change(Strategy, :count)
#        expect {find(:xpath, "//input[contains(@name, 'commit')]").click()}.not_to change(Strategy, :count)
#        expect {find_button("commit").trigger('click')}.not_to change(Strategy, :count)
#        expect {page.find("#edit-button").click}.not_to change(Strategy, :count)        
      end
      describe "error messages" do
        before {click_button "edit-button"}
        it {should have_content('error')}
      end
    end
    describe "with valid information" do
      before {fill_in 'strategy_name', with: "戦略１"}
      it "should create a strategy" do
        expect {click_button "edit-button"}.to change(Strategy, :count).by(1)
      end
    end
    describe "strategy destruction" do
      before { FactoryGirl.create(:strategy, user: user) }
      describe "as correct user" do
        before {visit strategies_path(user_id: @current_user.id)}
        it "should delete a strategy" do
#          expect { click_link "delete" }.to change(Strategy, :count).by(-1)
          expect { click_link "Destroy" }.to change(Strategy, :count).by(-1)
        end
      end
    end
  end

  # describe "GET /strategies" do
  #   it "works! (now write some real specs)" do
  #     # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
  #     get strategies_path
  #     response.status.should be(200)
  #   end
  # end
end
