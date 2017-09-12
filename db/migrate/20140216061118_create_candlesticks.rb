class CreateCandlesticks < ActiveRecord::Migration
  def change
    create_table :candlesticks do |t|
      t.date :tradingday
      t.integer :timezone
      t.integer :openvalue
      t.integer :highvalue
      t.integer :lowvalue
      t.integer :closevalue
      t.integer :dealings
      t.integer :salesvalue

      t.timestamps
    end
    add_index :candlesticks, [:tradingday, :timezone], :unique => true
  end
end
