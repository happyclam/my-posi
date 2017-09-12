# -*- coding:utf-8 -*-
# == Schema Information
#
# Table name: positions
#
#  id          :integer         not null, primary key
#  strategy_id :integer
#  distinct    :integer
#  exercise    :integer
#  expiration  :date
#  number      :integer
#  sale        :integer
#  unit        :decimal(, )
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  maturity    :float
#

require 'spec_helper'
require 'rails_helper'

describe Position,"CALLオプション:" do
#  pending "add some examples to (or delete) #{__FILE__}"
  # before(:each) do
  #   @position = Position.new(
  #                            :distinct => CALL,
  #                            :sale => BUY,
  #                            :exercise => 9250,
  #                            :unit => 105,
  #                            :number => 1,
  #                            :maturity => 26.0,
  #                            :ym_expiration => "2012/04"
  #                            )
  # end
  let(:strategy) {FactoryGirl.create(:strategy)}
  before {@position = strategy.positions.build(
                                               :distinct => CALL,
                                               :sale => BUY,
                                               :exercise => 9250,
                                               :unit => 105,
                                               :number => 1,
                                               :maturity => 26.0,
                                               :ym_expiration => "2012/04"
                                               )}
  it "strategy_idがセットされていない場合は無効" do
    @position.strategy = nil
    @position.should_not be_valid
  end
  it "商品種別がセットされていない場合は無効" do
    @position.distinct = nil
    @position.should_not be_valid
  end
  it "売買区分がセットされていない場合は無効" do
    @position.sale = nil
    @position.should_not be_valid
  end
  it "行使価格がセットされていない場合は無効" do
    @position.exercise = nil
    @position.should_not be_valid
  end
  it "単価がセットされていない場合は無効" do
    @position.unit = nil
    @position.should_not be_valid
  end
  it "数量がセットされていない場合は無効" do
    @position.number = nil
    @position.should_not be_valid
  end
  it "限月がセットされていない場合は無効" do
    @position.expiration = nil
    @position.should_not be_valid
  end
  it "残存日数がセットされていない場合は無効" do
    @position.maturity = nil
    @position.should_not be_valid
  end
  it "年月（ym_expiration）の入力で日付（１日）がセットされること" do
    @position.expiration.should == Date.strptime("2012/04/01", "%Y/%m/%d")
  end
  it "年月（ym_expiration）の取得が出来ること" do
    @position.ym_expiration.should == @position.expiration.strftime("%Y/%m")
  end
  it "オプション行使価格は２５０円刻み" do
    @position.exercise = 9240
    @position.should_not be_valid
  end
  it "オプション単価は１円刻み" do
    @position.unit = 105.2
    @position.should_not be_valid
  end
  # it "オプション単価は１～５００００" do
  #   @position.unit = 60000
  #   @position.should_not be_valid
  # end
  # it "オプション数量は１～１０００" do
  #   @position.number = 0.2
  #   @position.should_not be_valid
  # end
  it "positionのコピー" do
    @copy = Position.create(:distinct => @position.distinct,
                            :sale => @position.sale,
                            :exercise => @position.exercise,
                            :unit => @position.unit,
                            :number => @position.number,
                            :expiration => @position.expiration,
                            :maturity => @position.maturity
                            )
#    1.should eql 1
#    @copy.unit.should eql 105
    @copy.distinct.should eql @position.distinct
    @copy.sale.should eql @position.sale
    @copy.exercise.should eql @position.exercise
    @copy.unit.should eql @position.unit
    @copy.number.should eql @position.number
    @copy.expiration.should eql @position.expiration
    @copy.maturity.should eql @position.maturity
  end
  # it "オプション単価は１～５００００" do
  #   @position.unit = 60000
  #   @position.should_not be_valid
  # end
  # it "オプション数量は１～１０００" do
  #   @position.number = 0.2
  #   @position.should_not be_valid
  # end
  
  describe "#graph_data" do
    it "オプション価格計算が正しいこと1" do
      ans1,ans2 = @position.graph_data(9100, 0.15, 0.02)
      ans2.should be_within(1).of(-16936)
    end
    it "オプション価格計算が正しいこと2" do
      ans1,ans2 = @position.graph_data(9200, 0.15, 0.02)
      ans2.should be_within(1).of(24537)
    end
    it "オプション価格計算が正しいこと3" do
      ans1,ans2 = @position.graph_data(9300, 0.15, 0.02)
      ans2.should be_within(1).of(76743)
    end
    it "オプション価格計算が正しいこと4" do
      @position.sale = SELL
      ans1,ans2 = @position.graph_data(9100, 0.15, 0.02)
      ans2.should be_within(1).of(16936)
    end
    it "オプション価格計算が正しいこと5" do
      @position.sale = SELL
      ans1,ans2 = @position.graph_data(9200, 0.15, 0.02)
      ans2.should be_within(1).of(-24537)
    end
    it "オプション価格計算が正しいこと6" do
      @position.sale = SELL
      ans1,ans2 = @position.graph_data(9300, 0.15, 0.02)
      ans2.should be_within(1).of(-76743)
    end
  end
#------------------------------------------------------------------
  #日付を固定してテストするためにメソッド追加
  class Date
    def self.call_fixdaysbefore_today
      return Date.new(2012, 11, 5)
    end
    def self.call_fixsq_today
      return Date.new(2012, 11, 8)
    end
    def self.put_fixdaysbefore_today
      return Date.new(2012, 6, 5)
    end
    def self.put_fixsq_today
      return Date.new(2012, 6, 8)
    end
  end
  #日付(時間)を固定してテストするためにメソッド追加
  class Time
    def self.call_fixsq_now
      return Time.local(2012, 11, 8, 14, 30, 0)
    end
    def self.put_fixsq_now
      return Time.local(2012, 6, 7, 20, 30, 0)
    end
  end
#------------------------------------------------------------------
  describe "SQ４日前#get_remaining_str" do
    before(:all) do
      Date.instance_eval do
        alias :org_today :today
        alias :today :call_fixdaysbefore_today
      end
    end
#    before(:each) do
#    end
    it "SQ（第二金曜日）自動計算後、残存日数がセットされること" do
      @position.ym_expiration = "2012/11"      
      @position.maturity = nil
      @position.maturity_set
      @position.get_remaining_str.scan(/[+-]?[0-9]*[\.]?[0-9]+/)[0].should == "4.0"
    end
    it "過去の限月の場合残存日数が0になること1-1" do
      @position.maturity = nil
      @position.maturity_set
      @position.get_remaining_str.scan(/[+-]?[0-9]*[\.]?[0-9]+/)[0].should == "0.0"
    end
    it "過去の限月の場合残存日数が0になること1-2" do
      @position.ym_expiration = "2012/10"      
      @position.maturity = nil
      @position.maturity_set
      @position.get_remaining_str.scan(/[+-]?[0-9]*[\.]?[0-9]+/)[0].should == "0.0"
    end
    after(:all) do
      Date.instance_eval do
        alias :call_fixdaysbefore_today :today
        alias :today :org_today
      end
    end
  end

  describe "SQ当日#get_remaining_str" do
    before(:all) do
      Date.instance_eval do
        alias :org_today :today
        alias :today :call_fixsq_today
      end
      Time.instance_eval do
        alias :org_now :now
        alias :now :call_fixsq_now
      end
    end

    it "SQ（第二金曜日）自動計算後、残存日数が１日に満たない場合残存時間がセットされること" do
      @position.ym_expiration = "2012/11"      
      @position.maturity = nil
      @position.maturity_set
      @position.get_remaining_str.scan(/[+-]?[0-9]*[\.]?[0-9]+/)[0].should == "0.8"
    end
    it "過去の限月の場合残存日数が0になること2-1" do
      @position.maturity = nil
      @position.maturity_set
      @position.get_remaining_str.scan(/[+-]?[0-9]*[\.]?[0-9]+/)[0].should == "0.0"
    end
    it "過去の限月の場合残存日数が0になること2-2" do
      @position.ym_expiration = "2012/10"      
      @position.maturity = nil
      @position.maturity_set
      @position.get_remaining_str.scan(/[+-]?[0-9]*[\.]?[0-9]+/)[0].should == "0.0"
    end
    after(:all) do
      Date.instance_eval do
        alias :call_fixsq_today :today
        alias :today :org_today
      end
      Time.instance_eval do
        alias :call_fixsq_now :now
        alias :now :org_now
      end
    end
  end

end

describe Position,"PUTオプション:" do
  before(:each) do
    @position = Position.new(
#                             :strategy => mock_model("Strategy"),
                             :distinct => PUT,
                             :sale => BUY,
                             :exercise => 8750,
                             :unit => 120,
                             :number => 1,
                             :maturity => 10.0,
                             :ym_expiration => "2012/03"
                             )
  end
  it "商品種別がセットされていない場合は無効" do
    @position.distinct = nil
    @position.should_not be_valid
  end
  it "売買区分がセットされていない場合は無効" do
    @position.sale = nil
    @position.should_not be_valid
  end
  it "行使価格がセットされていない場合は無効" do
    @position.exercise = nil
    @position.should_not be_valid
  end
  it "単価がセットされていない場合は無効" do
    @position.unit = nil
    @position.should_not be_valid
  end
  it "数量がセットされていない場合は無効" do
    @position.number = nil
    @position.should_not be_valid
  end
  it "限月がセットされていない場合は無効" do
#    @position.expiration = nil
    @position.should_not be_valid
  end
  it "残存日数がセットされていない場合は無効" do
    @position.maturity = nil
    @position.should_not be_valid
  end
  it "年月（ym_expiration）の入力で日付（１日）がセットされること" do
    @position.expiration.should == Date.strptime("2012/03/01", "%Y/%m/%d")
  end
  it "年月（ym_expiration）の取得が出来ること" do
    @position.ym_expiration.should == @position.expiration.strftime("%Y/%m")
  end
  it "オプション行使価格は２５０円刻み" do
    @position.exercise = 8740
    @position.should_not be_valid
  end
  it "オプション単価は１円刻み" do
    @position.unit = 1.3
    @position.should_not be_valid
  end
  it "positionのコピー" do
    @copy = Position.create(:distinct => @position.distinct,
                            :sale => @position.sale,
                            :exercise => @position.exercise,
                            :unit => @position.unit,
                            :number => @position.number,
                            :expiration => @position.expiration,
                            :maturity => @position.maturity
                            )
    @copy.distinct.should eql @position.distinct
    @copy.sale.should eql @position.sale
    @copy.exercise.should eql @position.exercise
    @copy.unit.should eql @position.unit
    @copy.number.should eql @position.number
    @copy.expiration.should eql @position.expiration
    @copy.maturity.should eql @position.maturity
  end
  
  describe "#graph_data" do
    it "オプション価格計算が正しいこと1" do
      ans1,ans2 = @position.graph_data(8900, 0.16, 0.03)
      ans2.should be_within(1).of(-85062)
    end
    it "オプション価格計算が正しいこと2" do
      ans1,ans2 = @position.graph_data(8800, 0.16, 0.03)
      ans2.should be_within(1).of(-53130)
    end
    it "オプション価格計算が正しいこと3" do
      ans1,ans2 = @position.graph_data(8700, 0.16, 0.03)
      ans2.should be_within(1).of(-4874)
    end
    it "オプション価格計算が正しいこと4" do
      @position.sale = SELL
      ans1,ans2 = @position.graph_data(8900, 0.16, 0.03)
      ans2.should be_within(1).of(85062)
    end
    it "オプション価格計算が正しいこと5" do
      @position.sale = SELL
      ans1,ans2 = @position.graph_data(8800, 0.16, 0.03)
      ans2.should be_within(1).of(53130)
    end
    it "オプション価格計算が正しいこと6" do
      @position.sale = SELL
      ans1,ans2 = @position.graph_data(8700, 0.16, 0.03)
      ans2.should be_within(1).of(4874)
    end
  end

  describe "SQ４日前#get_remaining_str" do
    before(:all) do
      Date.instance_eval do
        alias :org_today :today
        alias :today :put_fixdaysbefore_today
      end
    end

    it "SQ（第二金曜日）自動計算後、残存日数がセットされること" do
      @position.ym_expiration = "2012/06"      
      @position.maturity = nil
      @position.maturity_set
      @position.get_remaining_str.scan(/[+-]?[0-9]*[\.]?[0-9]+/)[0].should == "3.0"
    end
    it "過去の限月の場合残存日数が0になること1-1" do
      @position.maturity = nil
      @position.maturity_set
      @position.get_remaining_str.scan(/[+-]?[0-9]*[\.]?[0-9]+/)[0].should == "0.0"
    end
    it "過去の限月の場合残存日数が0になること1-2" do
      @position.ym_expiration = "2012/05"      
      @position.maturity = nil
      @position.maturity_set
      @position.get_remaining_str.scan(/[+-]?[0-9]*[\.]?[0-9]+/)[0].should == "0.0"
    end
    after(:all) do
      Date.instance_eval do
        alias :put_fixdaysbefore_today :today
        alias :today :org_today
      end
    end
  end

  describe "SQ当日#get_remaining_str" do
    before(:all) do
      Date.instance_eval do
        alias :org_today :today
        alias :today :put_fixsq_today
      end
      Time.instance_eval do
        alias :org_now :now
        alias :now :put_fixsq_now
      end
    end

    it "SQ（第二金曜日）自動計算後、残存日数が１日に満たない場合残存時間がセットされること" do
      @position.ym_expiration = "2012/06"      
      @position.maturity = nil
      @position.maturity_set
      @position.get_remaining_str.scan(/[+-]?[0-9]*[\.]?[0-9]+/)[0].should == "0.5"
    end
    it "過去の限月の場合残存日数が0になること2-1" do
      @position.maturity = nil
      @position.maturity_set
      @position.get_remaining_str.scan(/[+-]?[0-9]*[\.]?[0-9]+/)[0].should == "0.0"
    end
    it "過去の限月の場合残存日数が0になること2-2" do
      @position.ym_expiration = "2012/05"      
      @position.maturity = nil
      @position.maturity_set
      @position.get_remaining_str.scan(/[+-]?[0-9]*[\.]?[0-9]+/)[0].should == "0.0"
    end
    after(:all) do
      Date.instance_eval do
        alias :put_fixsq_today :today
        alias :today :org_today
      end
      Time.instance_eval do
        alias :put_fixsq_now :now
        alias :now :org_now
      end
    end
  end

end

describe Position,"先物:" do
  before(:each) do
    @position = Position.new(
#                             :strategy => mock_model("Strategy"),
                             :distinct => FUTURES,
                             :sale => BUY,
                             :exercise => nil,
                             :unit => 8940,
                             :number => 1,
                             :maturity => nil,
                             :ym_expiration => "2012/07"
                             )
  end
  it "商品種別がセットされていない場合は無効" do
    @position.distinct = nil
    @position.should_not be_valid
  end
  it "売買区分がセットされていない場合は無効" do
    @position.sale = nil
    @position.should_not be_valid
  end
  it "行使価格がnil以外の場合はエラー" do
    @position.exercise = 10000
    @position.should_not be_valid
  end
  it "単価がセットされていない場合は無効" do
    @position.unit = nil
    @position.should_not be_valid
  end
  it "数量がセットされていない場合は無効" do
    @position.number = nil
    @position.should_not be_valid
  end
  it "限月がセットされていない場合は無効" do
    @position.expiration = nil
    @position.should_not be_valid
  end
  it "年月（ym_expiration）の入力で日付（１日）がセットされること" do
    @position.expiration.should == Date.strptime("2012/07/01", "%Y/%m/%d")
  end
  it "年月（ym_expiration）の取得が出来ること" do
    @position.ym_expiration.should == @position.expiration.strftime("%Y/%m")
  end
  it "先物価格は１０円刻み" do
    @position.exercise = 8705
    @position.should_not be_valid
  end
  it "先物単価は１円刻み" do
    @position.unit = 1.3
    @position.should_not be_valid
  end
  it "positionのコピー" do
    @copy = Position.create(:distinct => @position.distinct,
                            :sale => @position.sale,
                            :exercise => @position.exercise,
                            :unit => @position.unit,
                            :number => @position.number,
                            :expiration => @position.expiration,
                            :maturity => @position.maturity
                            )
    @copy.distinct.should eql @position.distinct
    @copy.sale.should eql @position.sale
    @copy.exercise.should eql @position.exercise
    @copy.unit.should eql @position.unit
    @copy.number.should eql @position.number
    @copy.expiration.should eql @position.expiration
    @copy.maturity.should eql @position.maturity
  end
  
  describe "#graph_data" do
    it "先物価格計算が正しいこと1" do
      ans1,ans2 = @position.graph_data(8900, 0.16, 0.03)
      ans2.should == -40000
    end
    it "先物価格計算が正しいこと2" do
      ans1,ans2 = @position.graph_data(8800, 0.16, 0.03)
      ans2.should == -140000
    end
    it "先物価格計算が正しいこと3" do
      ans1,ans2 = @position.graph_data(8700, 0.16, 0.03)
      ans2.should == -240000
    end
    it "先物価格計算が正しいこと4" do
      @position.sale = SELL
      ans1,ans2 = @position.graph_data(8900, 0.16, 0.03)
      ans2.should == 40000
    end
    it "先物価格計算が正しいこと5" do
      @position.sale = SELL
      ans1,ans2 = @position.graph_data(8800, 0.16, 0.03)
      ans2.should == 140000
    end
    it "先物価格計算が正しいこと6" do
      @position.sale = SELL
      ans1,ans2 = @position.graph_data(8700, 0.16, 0.03)
      ans2.should == 240000
    end
  end

end

describe Position,"先物ミニ:" do
  before(:each) do
    @position = Position.new(
#                             :strategy => mock_model("Strategy"),
                             :distinct => MINI,
                             :sale => BUY,
                             :exercise => nil,
                             :unit => 8940,
                             :number => 1,
                             :maturity => nil,
                             :ym_expiration => "2012/07"
                             )
  end
  it "商品種別がセットされていない場合は無効" do
    @position.distinct = nil
    @position.should_not be_valid
  end
  it "売買区分がセットされていない場合は無効" do
    @position.sale = nil
    @position.should_not be_valid
  end
  it "行使価格がnil以外の場合はエラー" do
    @position.exercise = 10000
    @position.should_not be_valid
  end
  it "単価がセットされていない場合は無効" do
    @position.unit = nil
    @position.should_not be_valid
  end
  it "数量がセットされていない場合は無効" do
    @position.number = nil
    @position.should_not be_valid
  end
  it "限月がセットされていない場合は無効" do
    @position.expiration = nil
    @position.should_not be_valid
  end
  it "年月（ym_expiration）の入力で日付（１日）がセットされること" do
    @position.expiration.should == Date.strptime("2012/07/01", "%Y/%m/%d")
  end
  it "年月（ym_expiration）の取得が出来ること" do
    @position.ym_expiration.should == @position.expiration.strftime("%Y/%m")
  end
  it "先物ミニ価格は５円刻み" do
    @position.exercise = 8703
    @position.should_not be_valid
  end
  it "先物ミニ単価は１円刻み" do
    @position.unit = 1.3
    @position.should_not be_valid
  end
  it "positionのコピー" do
    @copy = Position.create(:distinct => @position.distinct,
                            :sale => @position.sale,
                            :exercise => @position.exercise,
                            :unit => @position.unit,
                            :number => @position.number,
                            :expiration => @position.expiration,
                            :maturity => @position.maturity
                            )
    @copy.distinct.should eql @position.distinct
    @copy.sale.should eql @position.sale
    @copy.exercise.should eql @position.exercise
    @copy.unit.should eql @position.unit
    @copy.number.should eql @position.number
    @copy.expiration.should eql @position.expiration
    @copy.maturity.should eql @position.maturity
  end
  
  describe "#graph_data" do
    it "先物ミニ価格計算が正しいこと1" do
      ans1,ans2 = @position.graph_data(8900, 0.16, 0.03)
      ans2.should == -4000
    end
    it "先物ミニ価格計算が正しいこと2" do
      ans1,ans2 = @position.graph_data(8800, 0.16, 0.03)
      ans2.should == -14000
    end
    it "先物ミニ価格計算が正しいこと3" do
      ans1,ans2 = @position.graph_data(8700, 0.16, 0.03)
      ans2.should == -24000
    end
    it "先物ミニ価格計算が正しいこと4" do
      @position.sale = SELL
      ans1,ans2 = @position.graph_data(8900, 0.16, 0.03)
      ans2.should == 4000
    end
    it "先物ミニ価格計算が正しいこと5" do
      @position.sale = SELL
      ans1,ans2 = @position.graph_data(8800, 0.16, 0.03)
      ans2.should == 14000
    end
    it "先物ミニ価格計算が正しいこと6" do
      @position.sale = SELL
      ans1,ans2 = @position.graph_data(8700, 0.16, 0.03)
      ans2.should == 24000
    end
  end

end
