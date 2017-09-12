# -*- coding:utf-8 -*-
namespace :db do
          desc "テストデータ作成スクリプト"
          task :create_sample => :environment do
               require 'faker'
               Rake::Task['db:reset'].invoke
               make_users
               make_strategies
               make_positions
          end
end

def make_users
    tmp_user = User.new(:name => "test1")
    tmp_user.screen_name = tmp_user.name
    tmp_user.save!
    tmp_user = User.new(:name => "test2")
    tmp_user.screen_name = tmp_user.name
    tmp_user.save!
    tmp_user = User.new(:name => "2hikimenodojo")
    tmp_user.provider= "twitter"
    tmp_user.uid = "446878190"
    tmp_user.screen_name = tmp_user.name
    tmp_user.save!
    tmp_user = User.new(:name => "sample")
    tmp_user.screen_name = tmp_user.name
    tmp_user.save!
    25.times do |n|
            tmp_user = User.new(:name => Faker::Name.name)
            tmp_user.screen_name = tmp_user.name
            tmp_user.save!
    end
end

def make_strategies
    User.all.reverse.each_with_index do |user, n|
      if user.id == 4
        tmp_strategy = Strategy.new(:name => "カバード・コール(Covered Call)",
                        :sigma => 0.15,
                        :interest => 0.2,
                        :draw_type => 1,
                        :range => 1000
                       )
        tmp_strategy.user_id = user.id
        tmp_strategy.save!
        tmp_strategy = Strategy.new(:name => "カレンダー・スプレッド(Calendar Spread)",
                        :sigma => 0.15,
                        :interest => 0.2,
                        :range => 500,
                        :draw_type => 1
                       )
        tmp_strategy.user_id = user.id
        tmp_strategy.save!
        tmp_strategy = Strategy.new(:name => "レシオ・コール・スプレッド(Ratio Call Spread)",
                        :sigma => 0.15,
                        :interest => 0.2,
                        :range => 500,
                        :draw_type => nil
                       )
        tmp_strategy.user_id = user.id
        tmp_strategy.save!
        tmp_strategy = Strategy.new(:name => "レシオ・プット・スプレッド(Ratio Put Spread)",
                        :sigma => 0.15,
                        :interest => 0.2,
                        :range => 500,
                        :draw_type => 1
                       )
        tmp_strategy.user_id = user.id
        tmp_strategy.save!
        tmp_strategy = Strategy.new(:name => "ショート・ストラドル(Short Straddle)",
                        :sigma => 0.15,
                        :interest => 0.2,
                        :draw_type => 1,
                        :range => 1000
                       )
        tmp_strategy.user_id = user.id
        tmp_strategy.save!
        tmp_strategy = Strategy.new(:name => "ロング・ストラングル(Long Strangle)",
                        :sigma => 0.15,
                        :interest => 0.2,
                        :range => 500,
                        :draw_type => 1
                       )
        tmp_strategy.user_id = user.id
        tmp_strategy.save!
        tmp_strategy = Strategy.new(:name => "クレジット・プット・スプレッド(Credit Put Spread)",
                        :sigma => 0.15,
                        :interest => 0.2,
                        :range => 500,
                        :draw_type => 1
                       )
        tmp_strategy.user_id = user.id
        tmp_strategy.save!

      elsif user.id == 5 || user.id == 6
        25.times do |i|
          tmp_strategy = Strategy.new(:name => "戦略" + i.to_s,
                                 :sigma => 0.15,
                                 :interest => 0.2,
                                 :range => 500,
                                 :draw_type => ((i % 2)==0 ? 0 : 1)
                                 )
          tmp_strategy.user_id = user.id
          tmp_strategy.save!
        end
      elsif user.id == 8
      else
        tmp_strategy = Strategy.new(:name => "戦略" + n.to_s,
                                :sigma => 0.15,
                                :interest => 0.2,
                                :range => 500,
                                :draw_type => ((n % 2)==0 ? 0 : 1)
                                )
        tmp_strategy.user_id = user.id
        tmp_strategy.save!
      end
    end
end

def make_positions
    User.all.reverse.each do |user|
      Strategy.all.reverse.each do |strategy|
        if user.id == 1 && strategy.id == 1
          # Position.create(:distince => Faker::Lorem.sentence(10),
          #               :reference => Faker::Name.name,
          #               :remark => Faker::Lorem.sentence(10))
          strategy.positions.create(:distinct => CALL,
                               :sale => BUY,
                               :exercise => 10250,
                               :unit => 105,
                               :number => 1,
                               :maturity => 30.0,
                               :expiration => "2012/04/12")
          strategy.positions.create(:distinct => CALL,
                               :sale => SELL,
                               :exercise => 10500,
                               :unit => 60,
                               :number => 2,
                               :maturity => 30.0,
                               :expiration => "2012/04/12")
          strategy.positions.create(:distinct => MINI,
                               :sale => BUY,
                               :exercise => nil,
                               :unit => 10000,
                               :number => 1,
                               :maturity => nil,
                               :expiration => "2012/06/12")
          strategy.positions.each do |p|
            p.strategy_id = strategy.id
            p.save
          end                     
        end
  
        if user.id == 2 && strategy.id == 2
          strategy.positions.create(:distinct => CALL,
                               :sale => SELL,
                               :exercise => 10000,
                               :unit => 90,
                               :number => 1,
                               :maturity => 30.0,
                               :expiration => "2012/06/12")
          strategy.positions.create(:distinct => CALL,
                               :sale => SELL,
                               :exercise => 10250,
                               :unit => 45,
                               :number => 4,
                               :maturity => 30.0,
                               :expiration => "2012/06/12")
          strategy.positions.create(:distinct => CALL,
                               :sale => BUY,
                               :exercise => 10500,
                               :unit => 31,
                               :number => 4,
                               :maturity => 30.0,
                               :expiration => "2012/06/12")
          strategy.positions.create(:distinct => MINI,
                               :sale => BUY,
                               :exercise => nil,
                               :unit => 9965,
                               :number => 1,
                               :maturity => nil,
                               :expiration => "2012/06/12")
          strategy.positions.each do |p|
            p.strategy_id = strategy.id
            p.save
          end                     
        end
        #
        if user.id == 3 && strategy.id == 3
          strategy.positions.create(:distinct => CALL,
                               :sale => BUY,
                               :exercise => 9250,
                               :unit => 135,
                               :number => 1,
                               :maturity => 30.0,
                               :ym_expiration => "2012/06")
          strategy.positions.create(:distinct => CALL,
                               :sale => SELL,
                               :exercise => 9000,
                               :unit => 160,
                               :number => 1,
                               :maturity => 3.65,
                               :ym_expiration => "2012/05")
          strategy.positions.each do |p|
            p.strategy_id = strategy.id
            p.save
          end                     
        end
        #Covered Call
        if user.id == 4 && strategy.id == 4
          strategy.positions.create(:distinct => CALL,
                               :sale => SELL,
                               :exercise => 10000,
                               :unit => 100,
                               :number => 1,
                               :maturity => 30.0,
                               :ym_expiration => "2012/04")
          strategy.positions.create(:distinct => MINI,
                               :sale => BUY,
                               :exercise => nil,
                               :unit => 9950,
                               :number => 1,
                               :maturity => nil,
                               :ym_expiration => "2012/06")
          strategy.positions.each do |p|
            p.strategy_id = strategy.id
            p.save
          end                     
        end
        #Calendar Spread
        if user.id == 4 && strategy.id == 5
          strategy.positions.create(:distinct => CALL,
                               :sale => SELL,
                               :exercise => 9750,
                               :unit => 35.5,
                               :number => 4,
                               :maturity => 3.65,
                               :ym_expiration => "2012/05")
          strategy.positions.create(:distinct => CALL,
                               :sale => BUY,
                               :exercise => 9750,
                               :unit => 100,
                               :number => 1,
                               :maturity => 30.0,
                               :ym_expiration => "2012/06")
          strategy.positions.each do |p|
            p.strategy_id = strategy.id
            p.save
          end                     
        end
        #Ratio Call Spread      
        if user.id == 4  && strategy.id == 6
          strategy.positions.create(:distinct => CALL,
                               :sale => BUY,
                               :exercise => 10000,
                               :unit => 90,
                               :number => 1,
                               :maturity => 10.0,
                               :ym_expiration => "2012/06")
          strategy.positions.create(:distinct => CALL,
                               :sale => SELL,
                               :exercise => 10250,
                               :unit => 60,
                               :number => 2,
                               :maturity => 10.0,
                               :ym_expiration => "2012/06")
          strategy.positions.each do |p|
            p.strategy_id = strategy.id
            p.save
          end                     
        end
        #Ratio Put Spread
        if user.id == 4 && strategy.id == 7
          strategy.positions.create(:distinct => PUT,
                               :sale => BUY,
                               :exercise => 9000,
                               :unit => 200,
                               :number => 1,
                               :maturity => 10.0,
                               :ym_expiration => "2012/06")
          strategy.positions.create(:distinct => PUT,
                               :sale => SELL,
                               :exercise => 8750,
                               :unit => 120,
                               :number => 2,
                               :maturity => 10.0,
                               :ym_expiration => "2012/06")
          strategy.positions.each do |p|
            p.strategy_id = strategy.id
            p.save
          end                     
        end
        #Short Straddle
        if user.id == 4 && strategy.id == 8
          strategy.positions.create(:distinct => PUT,
                               :sale => SELL,
                               :exercise => 9000,
                               :unit => 200,
                               :number => 1,
                               :maturity => 30.0,
                               :ym_expiration => "2012/06")
          strategy.positions.create(:distinct => CALL,
                               :sale => SELL,
                               :exercise => 9000,
                               :unit => 220,
                               :number => 1,
                               :maturity => 30.0,
                               :ym_expiration => "2012/06")
          strategy.positions.each do |p|
            p.strategy_id = strategy.id
            p.save
          end                     
        end
        #Long Strangle
        if user.id == 4 && strategy.id == 9
          strategy.positions.create(:distinct => CALL,
                               :sale => BUY,
                               :exercise => 9250,
                               :unit => 105,
                               :number => 1,
                               :maturity => 30.0,
                               :ym_expiration => "2012/06")
          strategy.positions.create(:distinct => PUT,
                               :sale => BUY,
                               :exercise => 8750,
                               :unit => 90,
                               :number => 1,
                               :maturity => 30.0,
                               :ym_expiration => "2012/06")
          strategy.positions.each do |p|
            p.strategy_id = strategy.id
            p.save
          end                     
        end
        #Credit Put Spreadp
        if user.id == 4 && strategy.id == 10
          strategy.positions.create(:distinct => PUT,
                               :sale => SELL,
                               :exercise => 9000,
                               :unit => 170,
                               :number => 1,
                               :maturity => 30.0,
                               :ym_expiration => "2012/06")
          strategy.positions.create(:distinct => PUT,
                               :sale => BUY,
                               :exercise => 8750,
                               :unit => 90,
                               :number => 1,
                               :maturity => 30.0,
                               :ym_expiration => "2012/06")
          strategy.positions.each do |p|
            p.strategy_id = strategy.id
            p.save
          end                     
        end
        # if (user.id >= 5 && user.id <=7) && strategy.id == 1
        #   strategy.positions.create(:distinct => MINI,
        #                        :sale => BUY,
        #                        :exercise => nil,
        #                        :unit => 10000,
        #                        :number => 1,
        #                        :expiration => "2012/07/13",
        #                        :strategy_id => strategy.id)
        # end
      end #strategies
    end #users
end
