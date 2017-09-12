# -*- coding:utf-8 -*-
# == Schema Information
#
# Table name: strategies
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  name       :string(255)
#  draw_type  :integer
#  range      :integer         default(500)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  sigma      :float
#  interest   :float           default(0.02)
#

require 'spec_helper'
require 'rails_helper'

describe Strategy do
#  pending "add some examples to (or delete) #{__FILE__}"
  # before(:each) do
  #   @strategy = Strategy.new(
  #                            :range => 500,
  #                            :draw_type => INDIVIDUAL,
  #                            :sigma => nil
  #                            )
  # end
  let(:user) {FactoryGirl.create(:user)}
  before {@strategy = user.strategies.build(
                                            name: "戦略１",
                                            range: 500,
                                            draw_type: INDIVIDUAL,
                                            sigma: 0.2,
                                            interest: 0.1,
                                            )
  }
  subject {@strategy}
  it {should respond_to(:name)}
  it {should respond_to(:user_id)}
  it {should respond_to(:user)}
  its(:user) {should eq user}
  it {should be_valid}
  describe "when user_id is not present" do
    before {@strategy.user = nil}
    it {should_not be_valid}
  end
  it "user_idがセットされていない場合は無効" do
    @strategy.user = nil
    @strategy.should_not be_valid
  end
  it "グラフ描画範囲（range）がセットされていない場合は無効" do
    @strategy.range = nil
    @strategy.should_not be_valid
  end
  it "戦略名（name）がセットされていない場合は無効" do
    @strategy.name = nil
    @strategy.should_not be_valid
  end
  it "IV（sigma）がセットされていない場合は無効" do
    @strategy.sigma = 1.2
    @strategy.should_not be_valid
  end
  it "利息（interest）がセットされていない場合は無効" do
    @strategy.interest = nil
    @strategy.should_not be_valid
  end
  it "IV（sigma）未入力時にデフォルト値がセットされること" do
    @strategy.sigma = nil
    @strategy.sigma_set
    @strategy.sigma.should == SIGMA_DEFAULT
  end
  it "先物データがあれば先物の終値からIV（sigma）を計算しセットされること" do
    @strategy.sigma = nil
    @strategy.sigma_set
    @strategy.sigma.should be_within(1).of(0)
  end
end
