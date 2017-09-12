class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.integer :distinct
      t.integer :sale
      t.integer :exercise
      t.date :expiration
      t.float :maturity
      t.integer :number
      t.decimal :unit

      t.timestamps
    end
  end
end
