# -*- coding:utf-8 -*-
# == Schema Information
#
# Table name: positions
#
#  id          :integer          not null, primary key
#  distinct    :integer
#  sale        :integer
#  exercise    :integer
#  expiration  :date
#  maturity    :float
#  number      :integer
#  unit        :decimal(, )
#  created_at  :datetime
#  updated_at  :datetime
#  strategy_id :integer
#
require "myarray.rb"
require "mydate.rb"

class Position < ActiveRecord::Base
  #DBに無いカラム、年月のみの限月カラム
  attr_accessor :ym_expiration
  belongs_to :strategy, :touch => true
  validates :strategy, :presence => true
  validates :distinct, :presence => true, :inclusion => {:in => (FUTURES..PUT)}
  validates :sale, :presence => true, :inclusion => {:in => (SELL..BUY)}
  validates :exercise, :inclusion => {:in => (1..50000), :if => 'distinct == CALL || distinct == PUT'}, :presence => {:if => 'distinct == CALL || distinct == PUT'}
  validates :unit, :presence => true, :inclusion => {:in => (1..50000)}
  validates :number, :presence => true, :inclusion => {:in => (1..1000)}
  validates :expiration, :presence => true
  validates :maturity, inclusion: {in: (0.1 .. 365), if: 'distinct == CALL || distinct == PUT'}, presence: true, if: 'distinct == CALL || distinct == PUT'

  validate :unit_increment_is_valid?
  validate :exercise_increment_is_valid?

  before_update :maturity_before_update
  before_validation :maturity_set

  #これを省くとedit時のコンボに現在値をセットするのが面倒なのでオーバーライド
  def ym_expiration
    return self.expiration.strftime("%Y/%m") if self.expiration
  end
  #DBに無いカラム(年月だけのコンボボックス)からDB項目にセットするため
  def ym_expiration=(ym_expiration)
    self.expiration = MyDate.strptime(ym_expiration + "/01", "%Y/%m/%d")
  end

  #新規・編集時の限月コンボボックス用文字列配列を返すメソッド
  def get_expiration_list
    if self.expiration
      start = self.expiration
      #既存レコードの修正時は半年前の分からリストに追加
      6.times {
        start = start << 1
      }

    else
      #新規レコード時は現時点からリストに追加
      start = MyDate.today
    end

    buf = MyArray.new
    18.times{
      buf << start.strftime("%Y/%m")
      start = start >> 1
    }
    return buf
  end

  #残り日数表示文字列
  def get_remaining_str
    if (self.distinct == CALL) || (self.distinct == PUT)
      return "　満期（SQ）までの残り日数：" + sprintf("%.1f", self.maturity)
    else
      return ""
    end
  end
  #西暦付文字列
  def get_display_str
    distinct_str = {FUTURES => "先物", MINI => "先物mini", CALL => "C", PUT => "P"}
    sale_str = {SELL => "売", BUY => "買"}
    if self.distinct == FUTURES || self.distinct == MINI
      exercise_str = ""
    else
      exercise_str = self.exercise.to_s
    end
    expiration_str = self.expiration.strftime("%m")
    return expiration_str + distinct_str[self.distinct] + exercise_str + sale_str[self.sale] + sprintf("%g", self.unit) + "×" + self.number.to_s
  end
  #グラフの凡例用文字列
  def get_distinct_str
    distinct_str = {FUTURES => "先物", MINI => "先物mini", CALL => "C", PUT => "P"}
    sale_str = {SELL => "売", BUY => "買"}
    if self.distinct == FUTURES || self.distinct == MINI
      exercise_str = ""
    else
      exercise_str = self.exercise.to_s
    end
    expiration_str = self.expiration.strftime("%m")
    return expiration_str + distinct_str[self.distinct] + exercise_str + sale_str[self.sale]
  end

  #X軸の目盛りデータの最大値と最小値を決めるために使用
  def axis_data
    if self.distinct == FUTURES || self.distinct == MINI
      return self.unit
    else
      return self.exercise
    end
  end

  #X軸の目盛り時点の損益値を返す
  #asset:原資産価格
  #sigma:ボラティリティ
  #interest:確実性利子
  def graph_data(asset, sigma, interest)
    case self.distinct
    when FUTURES
      if self.sale == SELL
        buf = ((self.unit - asset) * self.number * 1000)
        return buf, buf
      else
        buf = ((asset - self.unit) * self.number * 1000)
        return buf, buf
      end
    when MINI
      if self.sale == SELL
        buf = ((self.unit - asset) * self.number * 100)
        return buf, buf
      else
        buf = ((asset - self.unit) * self.number * 100)
        return buf, buf
      end
    when CALL
      buf = call_price(asset, sigma, interest)
      if self.sale == SELL
        return ((self.unit - [asset - self.exercise, 0].max) * self.number * 1000),
        ((self.unit - [asset - self.exercise, buf].max) * self.number * 1000)
      else
        return (([asset - self.exercise, 0].max - self.unit) * self.number * 1000),
        (([asset - self.exercise,  buf].max - self.unit) * self.number * 1000)
      end
    when PUT
      buf = put_price(asset, sigma, interest)
      if self.sale == SELL
        return ((self.unit - [self.exercise - asset, 0].max) * self.number * 1000 ),
        ((self.unit - [self.exercise - asset, buf].max) * self.number * 1000)
      else
        return (([self.exercise - asset, 0].max - self.unit) * self.number * 1000), 
        (([self.exercise - asset, buf].max - self.unit) * self.number * 1000)
      end
    end
  end

  #残存日数の入力が無い場合に、現在からSQまでの残存日数を計算してセット
  def maturity_set
#p "position.maturity_set"
    self.maturity = case self.distinct
                    when FUTURES, MINI
                      nil
                    when CALL, PUT
                      if not self.maturity
                        maturity_def
                      else
                        self.maturity
                      end
                    else
                      nil
                    end
  end

  private
  #CALL価格
  def call_price(pv, sigma, interest)
    # return (
    #         pv * normsdist(d1(pv, sigma, interest)) - self.exercise * Math.exp(-1 * interest * (self.maturity / MATURITY_ANNUAL)) * normsdist(d2(pv, sigma, interest))
    #         )

    return (
            (pv * Math.exp(interest * (self.maturity / MATURITY_ANNUAL)) * normsdist(d1(pv, sigma, interest)) - self.exercise * normsdist(d2(pv, sigma, interest))) * Math.exp(-1 * interest * (self.maturity / MATURITY_ANNUAL))
            )
  end
  #PUT価格
  def put_price(pv, sigma, interest)
    # return (
    #         self.exercise * Math.exp(-1 * interest * (self.maturity / MATURITY_ANNUAL)) * normsdist(-1 * d2(pv, sigma, interest)) - pv * normsdist(-1 * d1(pv, sigma, interest))
    #         )

    return (
            (-1 * pv * Math.exp(interest * (self.maturity / MATURITY_ANNUAL)) * normsdist(-1 * d1(pv, sigma, interest)) + self.exercise * normsdist(-1 * d2(pv, sigma, interest))) * Math.exp(-1 * interest * (self.maturity / MATURITY_ANNUAL))
            )
  end
  
  #parameter:現在値,ボラティリティ,確実性利子
  def d1(pv, sigma, interest)
    buf = (Math.log(pv / self.exercise) + (interest * (self.maturity / MATURITY_ANNUAL))) / (sigma * Math.sqrt(self.maturity / MATURITY_ANNUAL)) + (sigma * Math.sqrt((self.maturity / MATURITY_ANNUAL)) / 2)
    return buf
  end
  #parameter:現在値,ボラティリティ,確実性利子
  def d2(pv, sigma, interest)
    buf = d1(pv, sigma, interest) - Math.sqrt((self.maturity / MATURITY_ANNUAL)) * sigma
    return buf
  end
  #parameter:累積正規確立密度関数(d1 or d2)
  def normsdist(value)
    buf = (Math.erf(value / Math.sqrt(2))) / 2 + 0.5
    return buf
  end

  def unit_increment_is_valid?
#p "position.unit_increment_is_valid"
    if self.unit 
      case self.distinct
      when FUTURES
        errors.add(:unit, ":日経平均先物の単価は#{STEP_F}円刻みです。") if (self.unit % STEP_F) != 0
      when MINI
        errors.add(:unit, ":日経平均先物miniの単価は#{STEP_M}円刻みです。") if (self.unit % STEP_M) != 0
      when CALL, PUT
        errors.add(:exercise, ":日経２２５オプションの単価は#{STEP_O}円刻みです。") if (self.unit % STEP_O) != 0
      else
      end
    end
  end

  def exercise_increment_is_valid?
#p "position.exercise_increment_is_valid"
    if self.exercise 
      case self.distinct
      when FUTURES, MINI
        self.exercise = nil unless self.exercise
      when CALL, PUT
        errors.add(:exercise, ":日経２２５オプションの行使価格は#{STEP_OP}円刻みです。") if (self.exercise % STEP_OP) != 0
      else
      end
    end
  end

  #残存日数の範囲外の入力をエラーにせずに強制的に置き換える
  def maturity_before_update
#p "position.maturity_before_update"
    if (self.distinct == FUTURES) || (self.distinct == MINI)
      self.maturity = nil
    else
      if self.maturity > MATURITY_ANNUAL
        self.maturity = MATURITY_ANNUAL
      elsif self.maturity < MATURITY_MINIMUM
        self.maturity = MATURITY_MINIMUM
      end
    end
  end

  #オプションの限月からSQ日を算出後、SQまでの残り日数を計算して返す
  def maturity_def
#p "position.maturity_def"
    base_day = MyDate.today
    base_time = Time.now
    maturity_day = base_day
    maturity_time = base_time
    30.times {|i|
      buf = self.expiration + i
      #第2金曜日がSQ
      if (buf.mwday == 2) && (buf.wday == 5)
        maturity_day = buf
        maturity_time = Time.mktime(buf.year, buf.month, buf.day, MATURITY_HOUR, 0, 0)        
        break
      end
    }
    remained = maturity_day - base_day
#p "remained=" + remained.to_s
    if remained > 1
      return remained
    elsif (remained >= 0) && (remained <= 1)
      #１日に満たない場合も日数換算して返す
      diff = (maturity_time.to_i - base_time.to_i) / (24 * 60 * 60).to_f
#p "diff=" + diff.to_s
      return (diff >= 0.1) ? diff : 0
    else
      return 0
    end
  end
end
