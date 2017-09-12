# == Schema Information
#
# Table name: users
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  provider    :string(255)
#  screen_name :string(255)
#  uid         :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

require 'spec_helper'
require 'rails_helper'
require 'rspec/collection_matchers'

describe User do
  before { @user = User.new(name: "User Name", screen_name: "ユーザ名") }

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:screen_name) }
  it { should respond_to(:strategies) }

  # describe "strategy associations" do
  #   before { @user.save }
  #   let!(:older_strategy) do
  #     FactoryGirl.create(:strategy, user: @user, created_at: 1.day.ago)
  #   end
  #   let!(:newer_strategy) do
  #     FactoryGirl.create(:strategy, user: @user, created_at: 1.hour.ago)
  #   end
  #   describe "status" do
  #     let(:unfollowed_post) do
  #       FactoryGirl.create(:strategy, user: FactoryGirl.create(:user))
  #     end
  #     its(:feed) { should include(newer_strategy) }
  #     its(:feed) { should include(older_strategy) }
  #     its(:feed) { should_not include(unfollowed_post) }
  #   end
  # end

  describe "when name is not present" do
    before {@user.name = " "}
    it {should_not be_valid}
  end
  describe "when screen_name is not present" do
    before {@user.screen_name = " "}
    it {should_not be_valid}
  end
end

describe User, "#name が設定されていない場合:" do
  before(:each) do
    @user = User.new
  end
  it "バリデーションに失敗すること" do
    @user.should_not be_valid
  end
  it ":name にエラーが設定されていること" do
    @user.should have(1).errors_on(:name)
#    expect(@user.errors_on(:name).size).to eql 1
#    should have(0).errors_on(:name)
#    expect(@user.errors_on(:name)).not_to be_empty
  end

end

describe User, "#screen_name が設定されていない場合:" do
  before(:each) do
    @user = User.new
  end
  it "バリデーションに失敗すること" do
    @user.should_not be_valid
  end
  it ":screen_name にエラーが設定されていること" do
    @user.should have(1).errors_on(:screen_name)
  end
end

describe User, "#name がユニークでない場合:" do
  before(:each) do
    @user1 = User.new
    @user1.name = "ネーム"
    @user1.screen_name = "スクリーンネーム"
    @user1.save
    @user2 = User.new
    @user2.name = "ネーム"
  end

  it "バリデーションに失敗すること" do
    validate_uniqueness_of(@user2.name)
  end
  it ":name にエラーが設定されていること" do
    @user2.should have(1).errors_on(:name)
  end

end

describe User, "#screen_name がユニークでない場合:" do
  before(:each) do
    @user1 = User.new
    @user1.name = "ネーム"
    @user1.screen_name = "スクリーンネーム"
    @user1.save
    @user2 = User.new
    @user2.screen_name = "スクリーンネーム"
  end

  it "バリデーションに失敗すること" do
    validate_uniqueness_of(@user2.screen_name)
  end
  it ":screen_name にエラーが設定されていること" do
    @user2.should have(1).errors_on(:screen_name)
  end

end

