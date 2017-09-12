# -*- coding:utf-8 -*-
# == Schema Information
#
# Table name: candlesticks
#
#  id         :integer          not null, primary key
#  tradingday :date
#  timezone   :integer
#  openvalue  :integer
#  highvalue  :integer
#  lowvalue   :integer
#  closevalue :integer
#  dealings   :integer
#  salesvalue :integer
#  created_at :datetime
#  updated_at :datetime
#

require "csv"
CSVFILENAME="./lib/futures.csv"

class Candlestick < ActiveRecord::Base
  validates :tradingday, :presence => true, :uniqueness => {:scope => [:tradingday, :timezone]}

  def self.test
    p "Hello"
  end

  def self.reading
    idx = 0
    CSV.foreach(CSVFILENAME){|row|
#      p row[1].encode("UTF-8", "SJIS", :invalid => :replace, :undef => :replace, :replace => '?')
      idx += 1
      #２行読み飛ばす
      if (idx <= 2)
        next
      end

#      tmp = row[1].encode("UTF-8", "SJIS", :invalid => :replace, :undef => :replace, :replace => '?')
#      tmp = row[1].encode("UTF-8", "UTF-8")
#      tmp = row[1].encode("UTF-8", "SHIFT_JIS")
      tmp = row[1]
      begin
        buf = Candlestick.new(
                               :tradingday => row[0],
                               :timezone => (tmp == "日中") ? DAYTIME : NIGHT,
                               :openvalue => row[2].to_i,
                               :highvalue => row[3].to_i,
                               :lowvalue => row[4].to_i,
                               :closevalue => row[5].to_i,
                               :dealings => row[6].to_i,
                               :salesvalue => row[7].to_i
                               )
        buf.save!
      # rescue ActiveRecord::RecordInvalid
      #   p "error! Line=" + idx.to_s + ":" + row[0] + "," + tmp
      rescue
        p $!
      else
        p "O.K."
#        p row[0] + "," + tmp + "," + buf.closevalue.to_s
#      ensure
#        next
      end
    }

  end

  def self.biteoff
    Candlestick.where("id != ?", "nil").delete_all()
    idx = 0
   
    CSV.foreach(CSVFILENAME){|row|
      if (idx < 2) 
        idx += 1
        next
      end

#      tmp = row[1].encode("UTF-8", "SJIS", :invalid => :replace, :undef => :replace, :replace => '?')
#      new_row = row.force_encoding("utf-8")
#      tmp = new_row[1]

      tmp = row[1]
#      tmp = row[1].encode("UTF-8", "UTF-8")
#      tmp = row[1].encode("UTF-8", "SHIFT_JIS")
      begin
        buf = Candlestick.new(
                               :tradingday => row[0],
                               :timezone => (tmp == "日中") ? DAYTIME : NIGHT,
                               :openvalue => row[2].to_i,
                               :highvalue => row[3].to_i,
                               :lowvalue => row[4].to_i,
                               :closevalue => row[5].to_i,
                               :dealings => row[6].to_i,
                               :salesvalue => row[7].to_i
                               )
        buf.save!
      rescue ActiveRecord::RecordInvalid
#        p $!
        p "error! Line=" + idx.to_s + ":" + buf[:tradingday].to_s + "," + buf[:timezone].to_s
        
      else
#        p "O.K."
        idx += 1
        p row[0] + "," + tmp + "," + buf.closevalue.to_s
      ensure
        if (idx >= 50)
          break
        end
      end
    }
    p "record count=" + (idx -2).to_s

  end

end
