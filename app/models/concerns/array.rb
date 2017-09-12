# -*- coding:utf-8 -*-
require "mathn"
class MyArray < Array
  # 要素をの平均を算出する
  def avg
    inject(0.0){|r,i| r += i } / size
  end
  # 要素をto_iした値の分散を算出する
  def variance
    a = avg
    inject(0.0){|r,i| r += (i - a) ** 2 } / size
  end
  # 要素をto_iした値の標準偏差を算出する
  def standard_deviation
    Math.sqrt(variance)
  end
end
