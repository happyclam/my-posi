# -*- coding:utf-8 -*-
require "date"
class MyDate < Date

  # 第n週目
  def mweek
    ((self.day + 6 + (self - self.day + 1).wday) / 7).to_i
  end

  # 第n曜日
  def mwday
    mw = mweek
    d = self - ((mw - 1) * 7)
    if self.month == d.month then
      mw
    else
      mw - 1
    end
  end
end
