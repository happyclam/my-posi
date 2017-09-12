# -*- coding:utf-8 -*-
# == Schema Information
#
# Table name: strategies
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  draw_type  :integer
#  range      :integer
#  interest   :float
#  sigma      :float
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer
#
require "myarray.rb"

class Strategy < ActiveRecord::Base
  belongs_to :user, :touch => true
  has_many :positions, :dependent => :delete_all
  paginates_per 15
  default_scope {order(updated_at: :desc)}

  validates :user, :presence => true
  validates :range, :presence => true
  validates :name, :presence => true
  validates :sigma, :presence => true, :inclusion => {:in => (0..1.1)}
  validates :interest, :presence => true, :inclusion => {:in => (0.01..0.5)}
  before_update :range_before_update, :unless => 'range >= RANGE_MIN && range <= RANGE_MAX'
  before_validation :sigma_set
  after_initialize :set_default_value

  def get_message_str
    buf = ""
    buf += self.user.screen_name + "のポジション＝"
    buf += self.get_positions_str
    buf += " - マイポジ"
  end

  def get_positions_str
    buf = ""
    self.positions.each do |p|
      buf += "「" + p.get_display_str + "」,"
    end
    buf = buf.chomp(",")
  end

  #ボラティリティの入力が無い場合に、過去の先物の終値データから計算してセット
  def sigma_set
#p "strategy.sigma_set"
    if !self.sigma || self.sigma == 0
      self.sigma = sigma_calc
    end
  end

  def draw_graph
    axis = Array.new
    graph_data = Array.new
    self.positions.each do |rec|
      axis << rec.axis_data
      graph_data << Array.new
    end
    graph_max = axis.max + self.range
    graph_min = axis.min - self.range
    total_data = Array.new
    bm_data = Array.new
    labels = Array.new
    distinct = Array.new

    if self.draw_type == INDIVIDUAL
    #グラフを建て玉ごとに描画
      idx = 0
      graph_min.step(graph_max, STEP_OP){|num|
        total = 0
        bm = 0
        self.positions.each_with_index do |posi, i|
          buf_f, buf_bm = posi.graph_data(num, self.sigma, self.interest)
          graph_data[i] << buf_f.to_i
          total += buf_f
          bm += buf_bm.to_f
        end
        labels[idx] = num.to_s
        total_data << total.to_i
        bm_data << bm.to_i
        idx += 1
      }
      graph_data.each_with_index do |g, i|
        distinct << {self.positions[i].get_distinct_str => g}
      end

    else
      #建て玉の合計を描画
      pre_bm_status = pre_total_status = 1
      bm_status = total_status = 1
      idx = 0
      graph_min.step(graph_max, 10){|num|
        total = 0
        bm = 0
        self.positions.each_with_index do |posi, i|
          buf_total, buf_bm = posi.graph_data(num, self.sigma, self.interest)
          total += buf_total
          bm += buf_bm.to_f
        end
        total_data << total.to_i
        bm_data << bm.to_i
        if total >= 0
          total_status = 1
        else
          total_status = 0
        end
        if bm >= 0
          bm_status = 1
        else
          bm_status = 0
        end

        if num == graph_min 
          pre_total_status = total_status
          pre_bm_status = bm_status
          labels[idx] = num.to_s
        elsif num > (graph_max - 10)
          labels[idx] = num.to_s
        else
          if pre_total_status != total_status
            pre_total_status = total_status
            labels[idx] = num.to_s
          elsif pre_bm_status != bm_status
            pre_bm_status = bm_status
            labels[idx] = num.to_s
          else
            labels[idx] = ""
          end
        end
        idx += 1
      }

    end
    graphs = LazyHighCharts::HighChart.new("graph") do |f|
      f.chart(:type => "line")
      f.chart(:width => "640")
      f.chart(:height => "480")
      f.title(:text => self.name)
################:headerFormat => '<b>先物価格: {point.key}</b><br />',
      f.tooltip(:pointFormat => '{series.name}: {point.y}<br />',
                :shared => true,
                :useHTML => true,
                :style => {margin: 0}
                )
      f.xAxis(:title => {:text => "先物価格"}, :categories => labels)
      f.yAxis(:title => {:text => "収益"})
      f.series(:name => "満期時計", :data => total_data)
      f.series(:name => "理論値計", :data => bm_data)
      distinct.each do |d|
        f.series(:name => d.keys[0], :data => d.values[0])
      end
      # f.series(:name => ["損益分岐線", "満期時計", "理論値計"]
      #          :data => [zero_data, total_data, bm_data])
      # f.series([:name => "損益分岐線", :data => zero_data],
      #          [:name => "満期時計", :data => total_data],
      #          [:name => "理論値計", :data => bm_data])
    end
    return graphs
  end


  private
  def set_default_value
    self.interest ||= INTEREST_DEFAULT
    self.range ||= RANGE_DEFAULT
  end

  #グラフの拡大縮小値が範囲外のときもエラーにせずに強制的に置き換える
  def range_before_update
#p "strategy.range_before_update"
    if self.range > RANGE_MAX
      self.range = RANGE_MAX
    elsif self.range < RANGE_MIN
      self.range = RANGE_MIN
    else
      self.range = RANGE_DEFAULT
    end

  end

  def sigma_calc
    hv_data = Candlestick.where("timezone=#{DAYTIME}").order("tradingday desc").limit(HV_RANGE + 1)
    if hv_data.size <= HV_RANGE 
      return SIGMA_DEFAULT
    end

    hv = MyArray.new
    pre_value = 0
    hv_data.each do |v|
      if pre_value == 0
        pre_value = v.closevalue
      else
        hv << Math.log(v.closevalue / pre_value)
        pre_value = v.closevalue
      end
    end
    return sprintf("%.3f", hv.standard_deviation * Math.sqrt(ANNUAL_TRADINGDAY))

  end

end
